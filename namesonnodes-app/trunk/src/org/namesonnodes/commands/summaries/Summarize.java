package org.namesonnodes.commands.summaries;

import java.util.Collection;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.namesonnodes.summarizers.Summarizer;
import org.namesonnodes.summarizers.SummarizerFactory;

public abstract class Summarize<E extends Persistent> extends AbstractCommand<List<SummaryItem>>
{
	private static final long serialVersionUID = 4081786941033997507L;
	private Command<? extends Collection<E>> entitiesCommand;
	private final Class<E> entityClass;
	public Summarize(final Class<E> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	@Override
	protected final String[] attributeNames()
	{
		final String[] n = { "entities" };
		return n;
	}
	@Override
	protected final Object[] attributeValues()
	{
		final Object[] v = { entitiesCommand };
		return v;
	}
	@Override
	protected final List<SummaryItem> doExecute(final Session session) throws CommandException
	{
		final Summarizer<E> summarizer = new SummarizerFactory(session).createSummarizer(entityClass);
		if (summarizer == null)
			throw new CommandException("Cannot summarize entities of class: " + entityClass.getName());
		final Collection<E> entities = acquire(entitiesCommand, session, "entities");
		return summarizer.summarize(entities);
	}
	public final Command<? extends Collection<E>> getEntitiesCommand()
	{
		return entitiesCommand;
	}
	public final boolean readOnly()
	{
		return entitiesCommand != null && entitiesCommand.readOnly();
	}
	public final boolean requiresCommit()
	{
		return commandRequiresCommit(entitiesCommand);
	}
	public final void setEntitiesCommand(final Command<? extends Collection<E>> entitiesCommand)
	{
		this.entitiesCommand = entitiesCommand;
	}
}
