package org.namesonnodes.commands;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.collection.PersistentCollection;

public abstract class AbstractCommand<E> implements Command<E>
{
	private static final long serialVersionUID = 1082973069668054565L;
	protected static <T> T acquire(final Command<T> command, final Session session, final String name)
	        throws CommandException
	{
		if (command == null)
			throw new CommandException("No " + name + " provided.");
		final T result = command.execute(session);
		// mergeResult(result, session);
		// if (command.requiresCommit())
		// session.flush();
		if (result == null)
			throw new CommandException("Cannot find " + name + ": " + command.toCommandString());
		if (result instanceof PersistentCollection)
			Hibernate.initialize(result);
		return result;
	}
	// protected static void mergeResult(final Object result, final Session
	// session)
	// {
	// mergeResult(result, session, new HashSet<Object>());
	// }
	// @SuppressWarnings("unchecked")
	// protected static void mergeResult(final Object result, final Session
	// session, final Set<Object> merged)
	// {
	// if (merged.contains(result))
	// return;
	// merged.add(result);
	// if (result instanceof Persistent)
	// {
	// session.merge(result);
	// }
	// else if (result instanceof Collection)
	// {
	// for (final Object subResult : (Collection) result)
	// mergeResult(subResult, session, merged);
	// }
	// }
	protected static boolean commandRequiresCommit(final Command<? extends Object> command)
	{
		return command != null && command.requiresCommit();
	}
	private boolean executed = false;
	private E result;
	protected abstract String[] attributeNames();
	protected abstract Object[] attributeValues();
	public void clearResult()
	{
		executed = false;
		result = null;
	}
	protected abstract E doExecute(final Session session) throws CommandException;
	public final E execute(final Session session) throws CommandException
	{
		if (!executed)
		{
			result = doExecute(session);
			executed = true;
		}
		return result;
	}
	public final String toCommandString()
	{
		return CommandUtil.write(getClass().getSimpleName(), attributeNames(), attributeValues());
	}
}
