package org.namesonnodes.commands.identity;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Identified;
import org.namesonnodes.domain.entities.Identifier;

public abstract class Equate<E extends Identified, I extends Identifier<E>> extends AbstractCommand<Set<I>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -8506642063485486833L;
	private boolean commitRequired = false;
	private final FindEquivalentEntities<E, I> findEquivalentEntities;
	private Command<E> entityCommand;
	private Command<? extends Collection<E>> oldEntitiesCommand;
	public Equate(final FindEquivalentEntities<E, I> findEquivalents)
	{
		super();
		this.findEquivalentEntities = findEquivalents;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "entity", "oldEntities" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { entityCommand, oldEntitiesCommand };
		return v;
	}
	@Override
	protected Set<I> doExecute(final Session session) throws CommandException
	{
		final E entity = acquire(entityCommand, session, "entity");
		final Collection<E> oldEntities = acquire(oldEntitiesCommand, session, "old entities");
		oldEntities.remove(entity);
		final Set<I> updates = new HashSet<I>();
		if (oldEntities == null || oldEntities.isEmpty())
			return updates;
		for (final E oldEntity : oldEntities)
		{
			findEquivalentEntities.setEntityCommand(new WrapEntity<E>(oldEntity));
			for (final I identifier : findEquivalentEntities.execute(session))
			{
				identifier.setEntity(entity);
				// :TODO: Use update?
				session.update(identifier);
				commitRequired = true;
				updates.add(identifier);
			}
		}
		for (final E oldEntity : oldEntities)
			if (session.contains(oldEntity))
			{
				session.delete(oldEntity);
				commitRequired = true;
			}
		return updates;
	}
	public final Command<E> getEntityCommand()
	{
		return entityCommand;
	}
	public final Command<? extends Collection<E>> getOldEntitiesCommand()
	{
		return oldEntitiesCommand;
	}
	public final boolean readOnly()
	{
		return false;
	}
	public final boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(entityCommand) || commandRequiresCommit(oldEntitiesCommand)
		        || commandRequiresCommit(findEquivalentEntities);
	}
	public final void setEntityCommand(final Command<E> entityCommand)
	{
		this.entityCommand = entityCommand;
	}
	public final void setOldEntitiesCommand(final Command<? extends Collection<E>> oldEntitiesCommand)
	{
		this.oldEntitiesCommand = oldEntitiesCommand;
	}
}
