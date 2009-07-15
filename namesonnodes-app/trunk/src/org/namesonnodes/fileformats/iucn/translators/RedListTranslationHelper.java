package org.namesonnodes.fileformats.iucn.translators;

import java.util.ArrayList;
import java.util.List;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.commands.collections.CommandSet;
import org.namesonnodes.commands.collections.ExtractElement;
import org.namesonnodes.commands.nomenclature.CreateUndefinedName;
import org.namesonnodes.commands.nomenclature.CreateVernacular;
import org.namesonnodes.commands.nomenclature.zoo.CreateZooSpeciesGroup;
import org.namesonnodes.commands.relate.IncludeTaxa;
import org.namesonnodes.commands.relate.SynonymizeTaxa;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.fileformats.iucn.model.CommonName;
import org.namesonnodes.fileformats.iucn.model.Species;
import org.namesonnodes.fileformats.iucn.model.Synonym;

public final class RedListTranslationHelper
{
	private static boolean areSpeciesNamesEquivalent(final String a, final String b)
	{
		if (a.equals(b))
			return true;
		final int aLength = a.length();
		final int bLength = b.length();
		if (Math.abs(aLength - bLength) > 2)
			return false;
		int minLength = aLength < bLength ? aLength : bLength;
		if (minLength <= 3)
			return false;
		minLength -= 2;
		return a.substring(0, minLength).equals(b.substring(0, minLength));
	}
	private final Command<Dataset> assessmentsCommand;
	private final Command<AuthorityIdentifier> redListCommand;
	private final Command<Dataset> taxonomyCommand;
	public RedListTranslationHelper(final Command<AuthorityIdentifier> redListCommand,
	        final Command<Dataset> taxonomyCommand, final Command<Dataset> assessmentsCommand)
	{
		super();
		this.redListCommand = redListCommand;
		this.taxonomyCommand = taxonomyCommand;
		this.assessmentsCommand = assessmentsCommand;
	}
	private CreateUndefinedName createSpeciesID(final Species species, final Command<Taxon> speciesCommand)
	{
		final CreateUndefinedName idCommand = new CreateUndefinedName();
		idCommand.setAuthorityCommand(redListCommand);
		idCommand.setItalics(true);
		idCommand.setLocalName("species:" + species.id);
		idCommand.setName(species.scientificName);
		idCommand.setEntityCommand(speciesCommand);
		return idCommand;
	}
	public Command<? extends Object> processSpecies(final Species species, final Command<Taxon> speciesCommand)
	{
		final CommandList<Object> commands = new CommandList<Object>();
		final Command<TaxonIdentifier> speciesIDCommand = createSpeciesID(species, speciesCommand);
		commands.add(speciesIDCommand);
		commands.addAll(translateCommonNames(species, speciesCommand));
		commands.addAll(translateSynonyms(species, speciesCommand, speciesIDCommand));
		commands.addAll(translateAssessment(species, speciesIDCommand));
		return commands;
	}
	private List<Command<? extends Object>> translateAssessment(final Species species,
	        final Command<TaxonIdentifier> speciesIDCommand)
	{
		final List<Command<? extends Object>> commands = new ArrayList<Command<? extends Object>>();
		final CommandList<TaxonIdentifier> subsetsCommand = new CommandList<TaxonIdentifier>();
		subsetsCommand.getCommands().add(speciesIDCommand);
		for (final Command<TaxonIdentifier> supersetCommand : species.assessment.commandsToDate())
		{
			final IncludeTaxa assessmentInclusionCommand = new IncludeTaxa();
			assessmentInclusionCommand.setDatasetCommand(assessmentsCommand);
			assessmentInclusionCommand.setSubsetsCommand(subsetsCommand);
			assessmentInclusionCommand.setSupersetCommand(supersetCommand);
			commands.add(assessmentInclusionCommand);
		}
		return commands;
	}
	private List<Command<? extends Object>> translateCommonNames(final Species species,
	        final Command<Taxon> taxonCommand)
	{
		final List<Command<? extends Object>> commands = new ArrayList<Command<? extends Object>>();
		for (final CommonName commonName : species.commonNames)
		{
			final CreateVernacular createVernacular = new CreateVernacular();
			createVernacular.setAuthorityCommand(redListCommand);
			createVernacular.setEntityCommand(taxonCommand);
			createVernacular.setLocalName("common_names:" + commonName.lang + ":" + commonName.name);
			createVernacular.setName(commonName.name);
			commands.add(createVernacular);
		}
		return commands;
	}
	private List<Command<? extends Object>> translateSynonyms(final Species species,
	        final Command<Taxon> speciesCommand, final Command<TaxonIdentifier> speciesIDCommand)
	{
		final List<Command<? extends Object>> commands = new ArrayList<Command<? extends Object>>();
		for (final Synonym synonym : species.synonyms)
			// Ignore subspecies, etc.
			if (synonym.infraRank == null && synonym.infraName == null)
			{
				final CreateZooSpeciesGroup createGroup = new CreateZooSpeciesGroup();
				createGroup.setBaseName(synonym.scientificName);
				if (areSpeciesNamesEquivalent(synonym.speciesName, species.speciesName))
				{
					// Assume objective synonymy if species names (epithets) are
					// identical or similar.
					createGroup.setTaxonCommand(speciesCommand);
					commands.add(createGroup);
				}
				else
				{
					// Otherwise, create subjective synonymy under IUCN Red List
					// taxonomy.
					commands.add(createGroup);
					final Command<TaxonIdentifier> synonymCommand = new ExtractElement<TaxonIdentifier>(createGroup, 2);
					final CommandSet<TaxonIdentifier> equivalents = new CommandSet<TaxonIdentifier>();
					equivalents.add(synonymCommand);
					equivalents.add(speciesIDCommand);
					commands.add(new SynonymizeTaxa(taxonomyCommand, equivalents));
				}
			}
		return commands;
	}
}
