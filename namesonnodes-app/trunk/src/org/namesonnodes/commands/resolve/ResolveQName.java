package org.namesonnodes.commands.resolve;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Qualified;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ResolveQName extends AbstractCommand<Qualified>
{
	private static final long serialVersionUID = -8512558356701661423L;
	private final ResolveDataset resolveDataset = new ResolveDataset();
	private final ResolveTaxonIdentifier resolveTaxonIdentifier = new ResolveTaxonIdentifier();
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "qname" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getQname() };
		return v;
	}
	@Override
	protected Qualified doExecute(final Session session) throws CommandException
	{
		final TaxonIdentifier taxonIdentifier = resolveTaxonIdentifier.execute(session);
		if (taxonIdentifier != null)
			return taxonIdentifier;
		return resolveDataset.execute(session);
	}
	public final String getQname()
	{
		return resolveDataset.getQname();
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setQname(final String qname)
	{
		resolveDataset.setQname(qname);
		resolveTaxonIdentifier.setQname(qname);
	}
}
