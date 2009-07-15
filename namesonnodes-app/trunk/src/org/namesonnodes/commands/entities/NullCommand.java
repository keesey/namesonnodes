package org.namesonnodes.commands.entities;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;

public final class NullCommand extends AbstractCommand<Object>
{
	private static final long serialVersionUID = -1981500250845582437L;
	private Command<? extends Object> command;
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "command" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { command };
		return v;
	}
	@Override
	protected Object doExecute(final Session session) throws CommandException
	{
		if (command != null)
			command.execute(session);
		return null;
	}
	public final Command<? extends Object> getCommand()
	{
		return command;
	}
	public boolean readOnly()
	{
		if (command == null)
			return true;
		return command.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(command);
	}
	public final void setCommand(final Command<? extends Object> command)
	{
		this.command = command;
	}
}
