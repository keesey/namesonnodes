package org.namesonnodes.commands.resolve;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ResolveTaxonIdentifierSet extends AbstractCommand<Set<TaxonIdentifier>>
{
	private static final long serialVersionUID = 6907023917017210349L;
	private final Set<String> qnames = new HashSet<String>();
	public ResolveTaxonIdentifierSet()
	{
		super();
	}
	public ResolveTaxonIdentifierSet(final Set<String> qNames)
	{
		super();
		setQnames(qNames);
	}
	public ResolveTaxonIdentifierSet(final String qNames)
	{
		this(qNames, "\n");
	}
	public ResolveTaxonIdentifierSet(final String qNames, final String separator)
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
	protected Set<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		final Set<TaxonIdentifier> list = new HashSet<TaxonIdentifier>();
		for (final String qName : qnames)
			list.add(new ResolveTaxonIdentifier(qName).execute(session));
		return list;
	}
	public final Set<String> getQnames()
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
	public final void setQnames(final Set<String> names)
	{
		qnames.clear();
		if (names != null)
			qnames.addAll(names);
	}
}
