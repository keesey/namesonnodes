package org.namesonnodes.commands.identity;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Taxon;

public final class CreateTaxon extends AbstractCommand<Taxon>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6901263515652145893L;
	private boolean commitRequired = false;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = {};
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = {};
		return v;
	}
	@Override
	protected Taxon doExecute(final Session session) throws CommandException
	{
		final Taxon taxon = new Taxon();
		session.save(taxon);
		commitRequired = true;
		return taxon;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
}
