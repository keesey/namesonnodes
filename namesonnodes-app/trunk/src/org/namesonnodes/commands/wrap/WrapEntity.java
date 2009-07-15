package org.namesonnodes.commands.wrap;

import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;

public class WrapEntity<E extends Persistent> implements Command<E>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -98797790537172575L;
	private E entity;
	public WrapEntity(final E entity)
	{
		super();
		setEntity(entity);
	}
	public void clearResult()
	{
	}
	public final E execute(final Session session) throws CommandException
	{
		return entity;
	}
	public final E getEntity()
	{
		return entity;
	}
	public boolean readOnly()
	{
		return true;
	}
	public final boolean requiresCommit()
	{
		return false;
	}
	public final void setEntity(final E entity)
	{
		this.entity = entity;
	}
	public final String toCommandString()
	{
		return entity == null ? "<null>" : entity.toString();
	}
}
