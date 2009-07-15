package org.namesonnodes.commands.load;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;

public abstract class Load<E extends Persistent> extends AbstractCommand<E>
{
	private static final long serialVersionUID = -9047458825729887811L;
	private final Class<E> entityClass;
	private int id;
	public Load(final Class<E> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "id" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { id };
		return v;
	}
	@Override
	protected E doExecute(final Session session) throws CommandException
	{
		return entityClass.cast(session.get(entityClass, id));
	}
	public final int getId()
	{
		return id;
	}
	public final boolean readOnly()
	{
		return true;
	}
	public final boolean requiresCommit()
	{
		return false;
	}
	public final void setId(final int id)
	{
		this.id = id;
	}
}
