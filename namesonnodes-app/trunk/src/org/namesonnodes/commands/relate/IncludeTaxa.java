package org.namesonnodes.commands.relate;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class IncludeTaxa extends AbstractCommand<Set<Inclusion>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4394582537335942895L;
	private static boolean hasInclusion(final Dataset dataset, final TaxonIdentifier superset,
	        final TaxonIdentifier subset)
	{
		for (final Inclusion inclusion : dataset.getInclusions())
			if (inclusion.getSuperset() == superset && inclusion.getSubset() == subset)
				return true;
		return false;
	}
	private boolean commitRequired;
	private Command<Dataset> datasetCommand;
	private Command<? extends Collection<TaxonIdentifier>> subsetsCommand;
	private Command<TaxonIdentifier> supersetCommand;
	public IncludeTaxa()
	{
		super();
	}
	public IncludeTaxa(final Command<Dataset> datasetCommand, final Command<TaxonIdentifier> supersetsCommand,
	        final Command<? extends Collection<TaxonIdentifier>> subsetsCommand)
	{
		super();
		this.datasetCommand = datasetCommand;
		this.supersetCommand = supersetsCommand;
		this.subsetsCommand = subsetsCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "supersets", "subsets", "dataset" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { supersetCommand, subsetsCommand, datasetCommand };
		return v;
	}
	@Override
	protected Set<Inclusion> doExecute(final Session session) throws CommandException
	{
		final Set<Inclusion> inclusions = new HashSet<Inclusion>();
		final TaxonIdentifier superset = acquire(supersetCommand, session, "superset");
		final Dataset dataset = acquire(datasetCommand, session, "dataset");
		final Collection<TaxonIdentifier> subsets = acquire(subsetsCommand, session, "subsets");
		if (!subsets.isEmpty())
			for (final TaxonIdentifier subset : subsets)
			{
				if (subset == null)
					throw new CommandException("Null identifier retrieved by: " + subsetsCommand.toCommandString());
				if (!hasInclusion(dataset, superset, subset))
				{
					final Inclusion inclusion = new Inclusion();
					inclusion.setSuperset(superset);
					inclusion.setSubset(subset);
					inclusions.add(inclusion);
				}
			}
		commitRequired = !inclusions.isEmpty();
		if (commitRequired)
			dataset.getInclusions().addAll(inclusions);
		return inclusions;
	}
	public final Command<Dataset> getDatasetCommand()
	{
		return datasetCommand;
	}
	public final Command<? extends Collection<TaxonIdentifier>> getSubsetsCommand()
	{
		return subsetsCommand;
	}
	public final Command<TaxonIdentifier> getSupersetCommand()
	{
		return supersetCommand;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(datasetCommand) || commandRequiresCommit(subsetsCommand)
		        || commandRequiresCommit(supersetCommand);
	}
	public final void setDatasetCommand(final Command<Dataset> datasetCommand)
	{
		this.datasetCommand = datasetCommand;
	}
	public final void setSubsetsCommand(final Command<? extends Collection<TaxonIdentifier>> subsetsCommand)
	{
		this.subsetsCommand = subsetsCommand;
	}
	public final void setSupersetCommand(final Command<TaxonIdentifier> supersetCommand)
	{
		this.supersetCommand = supersetCommand;
	}
}
