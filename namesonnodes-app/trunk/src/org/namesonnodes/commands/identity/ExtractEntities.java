package org.namesonnodes.commands.identity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Identified;
import org.namesonnodes.domain.entities.Identifier;

public abstract class ExtractEntities<E extends Identified, I extends Identifier<E>> extends AbstractCommand<List<E>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -7118414631815906334L;
	private Command<? extends Collection<I>> identifiersCommand;
	public ExtractEntities()
	{
		super();
	}
	public ExtractEntities(final Command<? extends Collection<I>> identifiersCommand)
	{
		super();
		this.identifiersCommand = identifiersCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "identifiers" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { identifiersCommand };
		return v;
	}
	@Override
	protected List<E> doExecute(final Session session) throws CommandException
	{
		final List<E> entities = new ArrayList<E>();
		for (final Identifier<E> identifier : acquire(identifiersCommand, session, "identifiers"))
			entities.add(identifier.getEntity());
		return entities;
	}
	public final Command<? extends Collection<I>> getIdentifiersCommand()
	{
		return identifiersCommand;
	}
	public final boolean readOnly()
	{
		if (identifiersCommand == null)
			return true;
		return identifiersCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(identifiersCommand);
	}
	public final void setIdentifiersCommand(final Command<? extends Collection<I>> identifiersCommand)
	{
		this.identifiersCommand = identifiersCommand;
	}
}
