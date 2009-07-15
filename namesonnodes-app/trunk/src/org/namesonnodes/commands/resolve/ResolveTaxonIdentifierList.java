package org.namesonnodes.commands.resolve;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ResolveTaxonIdentifierList extends AbstractCommand<List<TaxonIdentifier>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2189440509917807975L;
	private final List<String> qnames = new ArrayList<String>();
	public ResolveTaxonIdentifierList()
	{
		super();
	}
	public ResolveTaxonIdentifierList(final List<String> qNames)
	{
		super();
		setQnames(qNames);
	}
	public ResolveTaxonIdentifierList(final String qNames)
	{
		this(qNames, "\n");
	}
	public ResolveTaxonIdentifierList(final String qNames, final String separator)
	{
		super();
		if (qNames != null && qNames.length() > 0)
			for (final String qName : qNames.split(separator))
				this.qnames.add(qName);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "qNames" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { qnames };
		return v;
	}
	@Override
	protected List<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		final List<TaxonIdentifier> list = new ArrayList<TaxonIdentifier>();
		for (final String qname : qnames)
			list.add(new ResolveTaxonIdentifier(qname).execute(session));
		return list;
	}
	public final List<String> getQnames()
	{
		return qnames;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setQnames(final List<String> names)
	{
		qnames.clear();
		if (names != null)
			qnames.addAll(names);
	}
}
