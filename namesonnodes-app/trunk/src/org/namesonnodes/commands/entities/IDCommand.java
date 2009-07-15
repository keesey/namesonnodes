package org.namesonnodes.commands.entities;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;

public final class IDCommand extends AbstractCommand<Integer>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5359661910786617955L;
	private Command<? extends Persistent> entityCommand;
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "entity" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { entityCommand };
		return v;
	}
	@Override
	protected Integer doExecute(final Session session) throws CommandException
	{
		if (entityCommand == null)
			return null;
		final Persistent entity = entityCommand.execute(session);
		if (entity == null)
			return 0;
		return entity.getId();
	}
	public final Command<? extends Persistent> getEntityCommand()
	{
		return entityCommand;
	}
	public boolean readOnly()
	{
		if (entityCommand == null)
			return true;
		return entityCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(entityCommand);
	}
	public final void setEntityCommand(final Command<? extends Persistent> entityCommand)
	{
		this.entityCommand = entityCommand;
	}
}
