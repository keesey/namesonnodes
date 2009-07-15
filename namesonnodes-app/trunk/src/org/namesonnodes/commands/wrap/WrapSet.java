package org.namesonnodes.commands.wrap;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.utils.CollectionUtil;

public class WrapSet<E extends Persistent> implements Command<Set<E>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5214796572588087749L;
	private Set<E> entities;
	public WrapSet()
	{
		super();
	}
	public WrapSet(final Set<E> entities)
	{
		super();
		setEntities(entities);
	}
	public void clearResult()
	{
	}
	public final Set<E> execute(final Session session) throws CommandException
	{
		return entities;
	}
	public final Set<E> getEntities()
	{
		if (entities == null)
			entities = new HashSet<E>();
		return entities;
	}
	public boolean readOnly()
	{
		return true;
	}
	public final boolean requiresCommit()
	{
		return false;
	}
	public final void setEntities(final Set<E> entities)
	{
		this.entities = entities;
	}
	public final String toCommandString()
	{
		return "{" + CollectionUtil.join(getEntities(), ", ") + "}";
	}
}
