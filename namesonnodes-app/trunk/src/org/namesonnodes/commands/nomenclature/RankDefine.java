package org.namesonnodes.commands.nomenclature;

import java.util.Collection;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class RankDefine extends Define<RankDefinition>
{
	private static final long serialVersionUID = -3260873980284017178L;
	private boolean allowExisting = true;
	private double level;
	private String rank;
	private Command<? extends Collection<TaxonIdentifier>> typesCommand;
	public RankDefine()
	{
		super();
	}
	public RankDefine(final Command<TaxonIdentifier> identifierCommand, final String rank, final double level)
	{
		super();
		setIdentifierCommand(identifierCommand);
		setRank(rank);
		setLevel(level);
	}
	public RankDefine(final Command<TaxonIdentifier> identifierCommand, final String rank, final double level,
	        final Command<? extends Collection<TaxonIdentifier>> typesCommand)
	{
		this(identifierCommand, rank, level);
		setTypesCommand(typesCommand);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "identifier", "rank", "level", "types" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { identifierCommand, rank, level, typesCommand };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		final RankDefinition definition = new RankDefinition();
		final TaxonIdentifier identifier = acquireIdentifier(session);
		if (allowExisting)
		{
			final RankDefinition existing = (RankDefinition) identifier.getEntity().getDefinition();
			if (existing != null)
				return identifier;
		}
		definition.setRank(rank);
		definition.setLevel(level);
		if (typesCommand != null)
		{
			final Collection<TaxonIdentifier> types = acquire(typesCommand, session, "type[s]");
			for (final TaxonIdentifier type : types)
			{
				if (type == null)
					throw new CommandException("Invalid type.");
				if (type == identifier)
					throw new CommandException("Taxon name cannot be its own type.");
				if (type.getEntity() == identifier.getEntity())
					throw new CommandException("Rank-based definition cannot include an objective synonym ("
					        + type.getAuthority().getEntity().getLabel().getName() + ": " + type.getLabel().getName()
					        + ") as a type.");
				definition.getTypes().add(type);
			}
		}
		identifier.getEntity().setDefinition(definition);
		commitRequired = true;
		return identifier;
	}
	public final boolean getAllowExisting()
	{
		return allowExisting;
	}
	public double getLevel()
	{
		return level;
	}
	public final String getRank()
	{
		return rank;
	}
	public final Command<? extends Collection<TaxonIdentifier>> getTypesCommand()
	{
		return typesCommand;
	}
	@Override
	public boolean requiresCommit()
	{
		return super.requiresCommit() || commandRequiresCommit(typesCommand);
	}
	public final void setAllowExisting(final boolean allowExisting)
	{
		this.allowExisting = allowExisting;
	}
	public void setLevel(final double level)
	{
		this.level = level;
	}
	public final void setRank(final String rank)
	{
		this.rank = rank;
	}
	public final void setTypesCommand(final Command<? extends Collection<TaxonIdentifier>> typesCommand)
	{
		this.typesCommand = typesCommand;
	}
}
