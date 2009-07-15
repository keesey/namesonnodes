package org.namesonnodes.commands.relate;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Synonymy;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class SynonymizeTaxa extends AbstractCommand<Synonymy>
{
	private static final long serialVersionUID = 5199094123706029165L;
	private static Synonymy findExistingSynonymy(final Dataset dataset, final Collection<TaxonIdentifier> synonyms)
	{
		for (final Synonymy synonymy : dataset.getSynonymies())
			if (synonymy.getSynonyms().equals(synonyms))
				return synonymy;
		return null;
	}
	private boolean commitRequired;
	private Command<Dataset> datasetCommand;
	private Command<? extends Collection<TaxonIdentifier>> equivalentsCommand;
	public SynonymizeTaxa()
	{
		super();
	}
	public SynonymizeTaxa(final Command<Dataset> datasetCommand,
	        final Command<? extends Collection<TaxonIdentifier>> equivalentsCommand)
	{
		super();
		this.datasetCommand = datasetCommand;
		this.equivalentsCommand = equivalentsCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "equivalents", "dataset" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { equivalentsCommand, datasetCommand };
		return v;
	}
	@Override
	protected Synonymy doExecute(final Session session) throws CommandException
	{
		final Dataset dataset = acquire(datasetCommand, session, "dataset");
		final Set<TaxonIdentifier> equivalents = new HashSet<TaxonIdentifier>(acquire(equivalentsCommand, session,
		        "equivalents"));
		if (equivalents.size() <= 1)
			return null;
		// :TODO: check for objective synonymy.
		Synonymy synonymy = findExistingSynonymy(dataset, equivalents);
		if (synonymy != null)
			return synonymy;
		synonymy = new Synonymy();
		synonymy.setSynonyms(equivalents);
		dataset.getSynonymies().add(synonymy);
		return synonymy;
	}
	public final Command<Dataset> getDatasetCommand()
	{
		return datasetCommand;
	}
	public final Command<? extends Collection<TaxonIdentifier>> getEquivalentsCommand()
	{
		return equivalentsCommand;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(datasetCommand) || commandRequiresCommit(equivalentsCommand);
	}
	public final void setDatasetCommand(final Command<Dataset> datasetCommand)
	{
		this.datasetCommand = datasetCommand;
	}
	public final void setEquivalentsCommand(final Command<? extends Collection<TaxonIdentifier>> equivalentsCommand)
	{
		this.equivalentsCommand = equivalentsCommand;
	}
}
