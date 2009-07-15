package org.namesonnodes.commands.nomenclature;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.utils.URIUtil;

public abstract class ResolveCodeName extends AbstractCommand<TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 3831725261605806953L;
	private String name;
	public ResolveCodeName()
	{
		super();
	}
	public ResolveCodeName(final String name)
	{
		super();
		this.name = name;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		return new ResolveTaxonIdentifier(getCodeURI() + "::" + URIUtil.escape(name)).execute(session);
	}
	protected abstract String getCodeURI();
	public final String getName()
	{
		return name;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
}
