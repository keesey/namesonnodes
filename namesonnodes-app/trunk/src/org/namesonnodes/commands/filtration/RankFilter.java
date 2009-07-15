package org.namesonnodes.commands.filtration;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class RankFilter extends AbstractCommand<List<TaxonIdentifier>>
{
	private static final long serialVersionUID = 1285613837600648177L;

	private String rank;
	private Command<? extends Collection<TaxonIdentifier>> entitiesCommand;
	@Override
	protected String[] attributeNames()
	{
		return new String[] { "rank", "entities" };
	}
	@Override
	protected Object[] attributeValues()
	{
		return new Object[] { rank, entitiesCommand };
	}
	@Override
	protected List<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		if (rank == null || rank == "")
			throw new CommandException("No rank provided.");
		rank = rank.toLowerCase();
		final Collection<TaxonIdentifier> results = acquire(entitiesCommand, session, "entities");
		final List<TaxonIdentifier> filtered = new ArrayList<TaxonIdentifier>();
		for (final TaxonIdentifier result : results)
			if (result.getEntity().getDefinition() instanceof RankDefinition)
			{
				final RankDefinition def = (RankDefinition) result.getEntity().getDefinition();
				if (def.getRank().equals(rank))
					filtered.add(result);
			}
		return filtered;
	}
	public Command<? extends Collection<TaxonIdentifier>> getEntitiesCommand()
	{
		return entitiesCommand;
	}
	public String getRank()
	{
		return rank;
	}
	public boolean readOnly()
	{
		return entitiesCommand == null || entitiesCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(entitiesCommand);
	}
	public void setEntitiesCommand(final Command<? extends Collection<TaxonIdentifier>> entitiesCommand)
	{
		this.entitiesCommand = entitiesCommand;
	}
	public void setRank(final String rank)
	{
		this.rank = rank;
	}
}
