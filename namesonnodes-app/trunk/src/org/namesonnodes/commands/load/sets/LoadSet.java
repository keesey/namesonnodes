package org.namesonnodes.commands.load.sets;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;

public abstract class LoadSet<E extends Persistent> extends AbstractCommand<Set<E>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 7065276038349413778L;
	private final Class<E> entityClass;
	private Set<Integer> ids = new HashSet<Integer>();
	public LoadSet(final Class<E> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "ids" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { ids };
		return v;
	}
	@Override
	protected Set<E> doExecute(final Session session) throws CommandException
	{
		if (ids == null)
			return null;
		final Set<E> entities = new HashSet<E>();
		for (final Integer id : ids)
			entities.add(entityClass.cast(session.get(entityClass, id)));
		return entities;
	}
	public final Set<Integer> getIds()
	{
		return ids;
	}
	public final boolean readOnly()
	{
		return true;
	}
	public final boolean requiresCommit()
	{
		return false;
	}
	public final void setIds(final Set<Integer> ids)
	{
		this.ids = ids;
	}
}
