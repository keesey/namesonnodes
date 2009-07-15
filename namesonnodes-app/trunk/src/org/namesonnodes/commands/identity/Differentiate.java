package org.namesonnodes.commands.identity;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Identified;
import org.namesonnodes.domain.entities.Identifier;

public abstract class Differentiate<E extends Identified, I extends Identifier<E>> extends AbstractCommand<Set<I>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 3277567041677982830L;
	private Command<E> canonicalCommand;
	private boolean commitRequired = false;
	private Command<Set<I>> identifiersCommand;
	public Differentiate()
	{
		super();
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "canonical", "identifiers" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { canonicalCommand, identifiersCommand };
		return v;
	}
	protected abstract E createNewIdentified(final E canonical);
	@Override
	protected final Set<I> doExecute(final Session session) throws CommandException
	{
		final E canonical = acquire(canonicalCommand, session, "canonical identifier");
		final Set<I> identifiers = acquire(identifiersCommand, session, "identifier set");
		if (identifiers != null && identifiers.contains(canonical))
			throw new CommandException("Cannot differentiate canonical identifier from itself.");
		final Set<I> updates = new HashSet<I>();
		if (identifiers == null || identifiers.isEmpty())
			return updates;
		for (final I identifier : identifiers)
		{
			if (identifier == null)
				throw new CommandException("Null identifier.");
			if (identifier.getEntity().equals(canonical))
			{
				identifier.setEntity(createNewIdentified(canonical));
				updates.add(identifier);
				session.saveOrUpdate(identifier);
				commitRequired = true;
			}
		}
		return updates;
	}
	public final Command<E> getCanonicalCommand()
	{
		return canonicalCommand;
	}
	public final Command<Set<I>> getIdentifiersCommand()
	{
		return identifiersCommand;
	}
	public boolean readOnly()
	{
		return false;
	}
	public final boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setCanonicalCommand(final Command<E> canonicalCommand)
	{
		this.canonicalCommand = canonicalCommand;
	}
	public final void setIdentifiersCommand(final Command<Set<I>> entitiesCommand)
	{
		this.identifiersCommand = entitiesCommand;
	}
}
