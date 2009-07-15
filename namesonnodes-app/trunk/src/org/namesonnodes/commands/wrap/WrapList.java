package org.namesonnodes.commands.wrap;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.utils.CollectionUtil;

public class WrapList<E extends Persistent> implements Command<List<E>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4865926723072118922L;
	private List<E> entities;
	public WrapList()
	{
		super();
	}
	public WrapList(final List<E> entities)
	{
		super();
		setEntities(entities);
	}
	public void clearResult()
	{
	}
	public final List<E> execute(final Session session) throws CommandException
	{
		return entities;
	}
	public final List<E> getEntities()
	{
		if (entities == null)
			entities = new ArrayList<E>();
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
	public final void setEntities(final List<E> entities)
	{
		this.entities = entities;
	}
	public final String toCommandString()
	{
		return "{" + CollectionUtil.join(getEntities(), ", ") + "}";
	}
}
