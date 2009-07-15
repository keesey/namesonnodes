package org.namesonnodes.data.services;

import java.util.Collection;
import org.hibernate.FlushMode;
import org.hibernate.Hibernate;
import org.hibernate.exception.ConstraintViolationException;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.persist.HibernateBundle;

public final class CommandService
{
	private static void initialize(final Object o)
	{
		if (o instanceof Persistent)
			Hibernate.initialize(o);
		else if (o instanceof Collection<?>)
		{
			final Collection<?> collection = (Collection<?>) o;
			for (final Object o2 : collection)
				initialize(o2);
		}
	}
	// :TODO: Remove for production
	int calls = 0;
	public CommandService()
	{
		super();
	}
	public <R> R execute(final Command<R> command) throws CommandException
	{
		if (command == null)
			return null;
		// :TODO: Remove for production
		++calls;
		// :TODO: Remove for production
		System.out.println("[COMMAND #" + calls + "] " + command.toCommandString());
		HibernateBundle hb = null;
		R result = null;
		// :TODO: Remove for production
		long start = 0;
		// :TODO: Remove for production
		long end = 0;
		try
		{
			hb = new HibernateBundle();
			// :TODO: Remove for production
			start = System.currentTimeMillis();
			if (command.readOnly())
				hb.getSession().setFlushMode(FlushMode.MANUAL);
			result = command.execute(hb.getSession());
			if (command.requiresCommit())
				hb.commit();
			else
			{
				initialize(result);
				hb.cancel();
			}
			hb = null;
			// :TODO: Remove for production
			end = System.currentTimeMillis();
		}
		catch (final CommandException ex)
		{
			if (hb != null)
				hb.cancel();
			ex.printStackTrace();
			throw ex;
		}
		catch (final ConstraintViolationException ex)
		{
			if (hb != null)
				hb.cancel();
			ex.printStackTrace();
			throw new CommandException(ex.getMessage());
		}
		catch (final RuntimeException ex)
		{
			if (hb != null)
				hb.cancel();
			ex.printStackTrace();
			throw ex;
		}
		catch (final Exception ex)
		{
			if (hb != null)
				hb.cancel();
			ex.printStackTrace();
			throw new CommandException(ex);
		}
		// :TODO: Remove for production
		System.out.println("[COMMAND #" + calls + "] time elapsed: " + (end - start) + " ms");
		return result;
	}
	@SuppressWarnings("unchecked")
	public Object executeFlex(final Object command) throws CommandException
	{
		if (command instanceof Command)
			return execute((Command) command);
		throw new CommandException("No command sent.");
	}
}
