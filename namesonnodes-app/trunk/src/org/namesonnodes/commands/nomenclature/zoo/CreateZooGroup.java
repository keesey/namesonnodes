package org.namesonnodes.commands.nomenclature.zoo;

import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.utils.URIUtil.escape;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public abstract class CreateZooGroup<T> extends AbstractCommand<List<TaxonIdentifier>>
{
	private static final long serialVersionUID = 8798386503793243644L;
	protected boolean commitRequired;
	protected String baseName;
	protected Command<T> typeCommand;
	protected Command<Taxon> taxonCommand;
	public CreateZooGroup()
	{
		super();
	}
	public CreateZooGroup(final String baseName, final Command<T> typeCommand)
	{
		super();
		this.baseName = baseName;
		this.typeCommand = typeCommand;
	}
	public CreateZooGroup(final String baseName, final Command<T> typeCommand, final Command<Taxon> taxonCommand)
	{
		super();
		this.baseName = baseName;
		this.typeCommand = typeCommand;
		this.taxonCommand = taxonCommand;
	}
	@Override
	protected final String[] attributeNames()
	{
		final String[] n = { "baseName", "type", "taxon" };
		return n;
	}
	@Override
	protected final Object[] attributeValues()
	{
		final Object[] v = { baseName, typeCommand, taxonCommand };
		return v;
	}
	protected abstract String baseNamePattern();
	protected abstract String baseRank();
	protected final void checkBaseName() throws CommandException
	{
		if (baseName == null || baseName.length() == 0)
			throw new CommandException("No " + baseRank() + " name.");
		if (!baseName.matches(baseNamePattern()))
			throw new CommandException("Invalid zoological " + baseRank() + " name.");
	}
	protected abstract void checkExistingTypes(final TaxonIdentifier name, final String rank,
	        final Set<TaxonIdentifier> types) throws CommandException;
	protected abstract void checkType(final Set<TaxonIdentifier> type, final Session session) throws CommandException;
	protected abstract Set<TaxonIdentifier> convertTypes(final T type) throws CommandException;
	protected abstract List<TaxonIdentifier> createNames(final Session session, final AuthorityIdentifier code,
	        final Set<TaxonIdentifier> type) throws CommandException;
	protected final TaxonIdentifier defineName(final String name, final String abbr, final String rank,
	        final double level, final Set<TaxonIdentifier> types, final AuthorityIdentifier code, final Session session)
	        throws CommandException
	{
		final String localName = escape(name);
		final String qName = code.getUri() + "::" + localName;
		TaxonIdentifier nomen = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(eq("QName", qName))
		        .uniqueResult();
		if (nomen == null)
		{
			nomen = new TaxonIdentifier();
			nomen.setAuthority(code);
			if (taxonCommand == null || rank != baseRank())
				nomen.setEntity(new Taxon());
			else
				nomen.setEntity(acquire(taxonCommand, session, "taxon"));
			nomen.getLabel().setAbbr(abbr);
			nomen.getLabel().setItalics(italics());
			nomen.getLabel().setName(name);
			nomen.setLocalName(localName);
			session.save(nomen);
			commitRequired = true;
		}
		else if (nomen.getEntity().getDefinition() != null)
			if (nomen.getEntity().getDefinition() instanceof RankDefinition)
			{
				final RankDefinition rankDef = (RankDefinition) nomen.getEntity().getDefinition();
				if (!rankDef.getRank().equals(rank))
					throw new CommandException("Zoological " + rank + " name \"" + name
					        + "\" was already defined as rank " + rankDef.getRank() + ".");
				if (rankDef.getLevel() != level)
				{
					rankDef.setLevel(level);
					commitRequired = true;
				}
				checkExistingTypes(nomen, rank, types);
				return nomen;
			}
			else
				throw new CommandException("Zoological " + rank + " name \"" + name
				        + "\" was already give a non-rank-based definition.");
		final RankDefinition definition = new RankDefinition();
		definition.setLevel(level);
		definition.setRank(rank);
		definition.getTypes().addAll(types);
		nomen.getEntity().setDefinition(definition);
		commitRequired = true;
		return nomen;
	}
	@Override
	protected final List<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		checkBaseName();
		final Set<TaxonIdentifier> type = typeCommand == null ? new HashSet<TaxonIdentifier>() : convertTypes(acquire(
		        typeCommand, session, "type"));
		checkType(type, session);
		final AuthorityIdentifier code = findCode(session);
		final List<TaxonIdentifier> names = createNames(session, code, type);
		commitRequired = true;
		return names;
	}
	protected final AuthorityIdentifier findCode(final Session session) throws CommandException
	{
		return acquire(new ZoologicalCode(), session, "zoological code");
	}
	public final String getBaseName()
	{
		return baseName;
	}
	public final Command<Taxon> getTaxonCommand()
	{
		return taxonCommand;
	}
	public final Command<T> getTypeCommand()
	{
		return typeCommand;
	}
	protected abstract boolean italics();
	public final boolean readOnly()
	{
		return false;
	}
	public final boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(typeCommand);
	}
	public final void setBaseName(final String baseName)
	{
		this.baseName = baseName;
	}
	public final void setTaxonCommand(final Command<Taxon> taxonCommand)
	{
		this.taxonCommand = taxonCommand;
	}
	public final void setTypeCommand(final Command<T> typeCommand)
	{
		this.typeCommand = typeCommand;
	}
}