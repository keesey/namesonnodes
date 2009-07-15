package org.namesonnodes.commands.load.lists;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;

public abstract class LoadList<E extends Persistent> extends AbstractCommand<List<E>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -7355333436111178031L;
	private final Class<E> entityClass;
	private List<Integer> ids;
	public LoadList(final Class<E> entityClass)
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
	protected List<E> doExecute(final Session session) throws CommandException
	{
		if (ids == null)
			return null;
		final List<E> entities = new ArrayList<E>();
		for (final Integer id : ids)
			entities.add(entityClass.cast(session.get(entityClass, id)));
		return entities;
	}
	public final List<Integer> getIds()
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
	public final void setIds(final List<Integer> ids)
	{
		this.ids = ids;
	}
}
