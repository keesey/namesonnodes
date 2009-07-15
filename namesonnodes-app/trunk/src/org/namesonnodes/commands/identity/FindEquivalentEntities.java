package org.namesonnodes.commands.identity;

import static org.hibernate.criterion.Restrictions.eq;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Identified;
import org.namesonnodes.domain.entities.Identifier;

public abstract class FindEquivalentEntities<E extends Identified, I extends Identifier<E>> extends
        AbstractCommand<Set<I>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4867470624930800246L;
	private Command<E> entityCommand;
	public FindEquivalentEntities()
	{
		super();
	}
	public FindEquivalentEntities(final Command<E> entityCommand)
	{
		super();
		this.entityCommand = entityCommand;
	}
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
	@SuppressWarnings("unchecked")
	@Override
	protected final Set<I> doExecute(final Session session) throws CommandException
	{
		final E entity = acquire(entityCommand, session, "entity");
		final List list = session.createCriteria(getIdentifierClass()).add(eq("entity", entity)).list();
		final Set<I> results = new HashSet<I>();
		for (final Object item : list)
			results.add(getIdentifierClass().cast(item));
		return results;
	}
	public final Command<E> getEntityCommand()
	{
		return entityCommand;
	}
	protected abstract Class<I> getIdentifierClass();
	public final boolean readOnly()
	{
		if (entityCommand == null)
			return true;
		return entityCommand.readOnly();
	}
	public final boolean requiresCommit()
	{
		return commandRequiresCommit(entityCommand);
	}
	public final void setEntityCommand(final Command<E> entityCommand)
	{
		this.entityCommand = entityCommand;
	}
}
