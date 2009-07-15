package org.namesonnodes.commands.identity;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Identified;
import org.namesonnodes.domain.entities.Identifier;

public abstract class ExtractEntity<E extends Identified, I extends Identifier<E>> extends AbstractCommand<E>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6425336606025113694L;
	private Command<I> identifierCommand;
	public ExtractEntity()
	{
		super();
	}
	public ExtractEntity(final Command<I> identifierCommand)
	{
		super();
		this.identifierCommand = identifierCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "identifier" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { identifierCommand };
		return v;
	}
	@Override
	protected E doExecute(final Session session) throws CommandException
	{
		return acquire(identifierCommand, session, "identifier").getEntity();
	}
	public final Command<I> getIdentifierCommand()
	{
		return identifierCommand;
	}
	public final boolean readOnly()
	{
		if (identifierCommand == null)
			return true;
		return identifierCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(identifierCommand);
	}
	public final void setIdentifierCommand(final Command<I> identifierCommand)
	{
		this.identifierCommand = identifierCommand;
	}
}
