package org.namesonnodes.commands.nomenclature;

import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.utils.CollectionUtil.join;
import java.util.HashSet;
import java.util.Set;
import javax.xml.transform.TransformerException;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.PhyloDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.phylo.PhyloMath;
import org.namesonnodes.utils.DocumentUtil;
import org.namesonnodes.w3c.MathML;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public final class PhyloDefine extends Define<PhyloDefinition>
{
	private static final long serialVersionUID = -6332190716518902215L;
	private static Set<String> findQNamesInFormula(final Document document) throws CommandException
	{
		final Set<String> qNames = new HashSet<String>();
		final NodeList nodes = document.getElementsByTagNameNS(MathML.NAMESPACE.getURI(), MathML.CSYMBOL);
		final int n = nodes.getLength();
		for (int i = 0; i < n; ++i)
		{
			final Node node = nodes.item(i);
			Node definitionURL = node.getAttributes().getNamedItemNS(MathML.NAMESPACE.getURI(), MathML.DEFINITION_URL);
			if (definitionURL == null)
				definitionURL = node.getAttributes().getNamedItemNS(null, MathML.DEFINITION_URL);
			if (definitionURL == null)
				throw new CommandException("A \"csymbol\" elements lacks a \"definitionURL\" attribute.");
			qNames.add(definitionURL.getTextContent());
		}
		return qNames;
	}
	private static Set<TaxonIdentifier> findSpecifiersInFormula(final Document formula, final Session session,
	        final Set<String> prohibitedQNames) throws CommandException
	{
		final Set<TaxonIdentifier> specifiers = new HashSet<TaxonIdentifier>();
		final Set<String> unknownQNames = new HashSet<String>();
		for (final String qName : findQNamesInFormula(formula))
			if (!qName.startsWith(PhyloMath.NAMESPACE.getURI() + "::"))
			{
				if (prohibitedQNames.contains(qName))
					throw new CommandException("Definition cannot refer to the name being defined.");
				final TaxonIdentifier specifier = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(
				        eq("QName", qName)).uniqueResult();
				if (specifier == null)
					unknownQNames.add(qName);
				else
					specifiers.add(specifier);
			}
		if (!unknownQNames.isEmpty())
			throw new CommandException("Could not locate taxa for the following qualified name"
			        + (unknownQNames.size() == 1 ? "" : "s") + ": <" + join(unknownQNames, ">, <") + ">.");
		return specifiers;
	}
	private Document formula;
	private String prose;
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "identifier", "authority", "prose", "formula" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { identifierCommand, authorityCommand, prose, formula };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (formula == null)
			throw new CommandException("No mathematical formula.");
		if (prose == null || prose.length() < 8)
			throw new CommandException("No prose definition.");
		final PhyloDefinition definition = new PhyloDefinition();
		final Set<String> prohibitedSpecifierQNames = new HashSet<String>();
		final TaxonIdentifier identifier = acquireIdentifier(session);
		prohibitedSpecifierQNames.add(identifier.getQName());
		try
		{
			definition.setFormula(DocumentUtil.write(formula));
		}
		catch (final TransformerException ex)
		{
			throw new CommandException(ex);
		}
		definition.setProse(prose);
		definition.setSpecifiers(findSpecifiersInFormula(formula, session, prohibitedSpecifierQNames));
		if (definition.getSpecifiers().isEmpty())
			throw new CommandException("No specifiers in formula.");
		identifier.getEntity().setDefinition(definition);
		commitRequired = true;
		return identifier;
	}
	public final Document getFormula()
	{
		return formula;
	}
	public final String getProse()
	{
		return prose;
	}
	public final void setFormula(final Document formula)
	{
		this.formula = formula;
	}
	public final void setProse(final String prose)
	{
		this.prose = prose;
	}
}
