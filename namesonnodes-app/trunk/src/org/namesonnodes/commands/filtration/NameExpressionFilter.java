package org.namesonnodes.commands.filtration;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Labelled;

public class NameExpressionFilter<L extends Labelled> extends AbstractCommand<List<L>>
{
	private static final long serialVersionUID = -9089626757957475345L;
	private String expression = ".?";
	private int maxResults = Integer.MAX_VALUE;
	private Command<? extends Collection<L>> entitiesCommand;
	@Override
	protected final String[] attributeNames()
	{
		final String[] n = { "expression", "entities", "maxResults" };
		return n;
	}
	@Override
	protected final Object[] attributeValues()
	{
		final Object[] v = { expression, entitiesCommand, maxResults };
		return v;
	}
	@Override
	protected final List<L> doExecute(final Session session) throws CommandException
	{
		final Collection<L> entities = acquire(entitiesCommand, session, "entities");
		final List<L> filtered = new ArrayList<L>();
		if (maxResults > 0)
			for (final L entity : entities)
				if (entity.getLabel().getName().matches(expression))
				{
					filtered.add(entity);
					if (filtered.size() >= maxResults)
						break;
				}
		return filtered;
	}
	public final Command<? extends Collection<L>> getEntitiesCommand()
	{
		return entitiesCommand;
	}
	public final String getExpression()
	{
		return expression;
	}
	public final int getMaxResults()
	{
		return maxResults;
	}
	public final boolean readOnly()
	{
		return entitiesCommand == null || entitiesCommand.readOnly();
	}
	public final boolean requiresCommit()
	{
		return commandRequiresCommit(entitiesCommand);
	}
	public final void setEntitiesCommand(final Command<? extends Collection<L>> entitiesCommand)
	{
		this.entitiesCommand = entitiesCommand;
	}
	public final void setExpression(final String expression)
	{
		this.expression = expression;
	}
	public final void setMaxResults(final int maxResults)
	{
		this.maxResults = maxResults;
	}
}
