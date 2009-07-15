package org.namesonnodes.commands.resolve;

import static org.hibernate.criterion.Restrictions.ilike;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Dataset;

public final class ResolveDataset extends AbstractCommand<Dataset>
{
	private static final long serialVersionUID = -4959120417867282275L;
	private String qname;
	public ResolveDataset()
	{
		super();
	}
	public ResolveDataset(final String qname)
	{
		super();
		this.qname = qname;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "qname" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { qname };
		return v;
	}
	@Override
	protected Dataset doExecute(final Session session) throws CommandException
	{
		if (qname == null || qname == "")
			throw new CommandException("No qualified name provided.");
		return (Dataset) session.createCriteria(Dataset.class).add(ilike("QName", qname)).uniqueResult();
	}
	public final String getQname()
	{
		return qname;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setQname(final String name)
	{
		qname = name;
	}
}
