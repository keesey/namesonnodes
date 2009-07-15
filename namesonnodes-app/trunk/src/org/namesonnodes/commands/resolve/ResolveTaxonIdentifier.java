package org.namesonnodes.commands.resolve;

import static org.hibernate.criterion.Restrictions.ilike;
import static org.namesonnodes.utils.URIUtil.escape;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ResolveTaxonIdentifier extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = -6498902197145251222L;
	private String qname;
	public ResolveTaxonIdentifier()
	{
		super();
	}
	public ResolveTaxonIdentifier(final String qname)
	{
		super();
		setQname(qname);
	}
	public ResolveTaxonIdentifier(final String uri, final String localName)
	{
		this(uri + "::" + escape(localName));
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
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (qname == null || qname == "")
			throw new CommandException("No qualified name.");
		return (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(ilike("QName", qname))
		        .uniqueResult();
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
