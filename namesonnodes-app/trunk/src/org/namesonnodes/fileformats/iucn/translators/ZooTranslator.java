package org.namesonnodes.fileformats.iucn.translators;

import static org.namesonnodes.fileformats.iucn.translators.IUCNRedList.ASSESSMENTS_QNAME;
import static org.namesonnodes.fileformats.iucn.translators.IUCNRedList.TAXONOMY_QNAME;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.commands.collections.ExtractElement;
import org.namesonnodes.commands.identity.CreateTaxon;
import org.namesonnodes.commands.nomenclature.RankDefine;
import org.namesonnodes.commands.nomenclature.zoo.CreateZooFamilyGroup;
import org.namesonnodes.commands.nomenclature.zoo.CreateZooGenusGroup;
import org.namesonnodes.commands.nomenclature.zoo.CreateZooSpeciesGroup;
import org.namesonnodes.commands.nomenclature.zoo.CreateZooUndefinedName;
import org.namesonnodes.commands.relate.IncludeTaxa;
import org.namesonnodes.commands.resolve.ResolveDataset;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.fileformats.iucn.model.Species;

public final class ZooTranslator implements SpeciesTranslator
{
	private static boolean isTypeGenus(final Species species)
	{
		final String genusRoot = species.genusName.substring(0, species.genusName.length() - 2);
		final String familyRoot = species.familyName.substring(0, species.familyName.length() - 4);
		return familyRoot.startsWith(genusRoot);
	}
	protected final Command<Dataset> assessmentsCommand = new ResolveDataset(ASSESSMENTS_QNAME);
	protected final Command<AuthorityIdentifier> redListCommand = new ResolveURI(IUCNRedList.URI);
	protected final Command<Dataset> taxonomyCommand = new ResolveDataset(TAXONOMY_QNAME);
	protected final RedListTranslationHelper helper = new RedListTranslationHelper(redListCommand, taxonomyCommand,
	        assessmentsCommand);
	private final Map<String, Command<TaxonIdentifier>> nameMap = new HashMap<String, Command<TaxonIdentifier>>();
	private final Map<Command<TaxonIdentifier>, Map<Command<TaxonIdentifier>, Command<Set<Inclusion>>>> inclusionMap = new HashMap<Command<TaxonIdentifier>, Map<Command<TaxonIdentifier>, Command<Set<Inclusion>>>>();
	protected Command<Set<Inclusion>> createDefinitionInclusionCommand(final Command<TaxonIdentifier> supersetCommand,
	        final Command<TaxonIdentifier> subsetCommand)
	{
		if (inclusionMap.containsKey(supersetCommand))
		{
			if (inclusionMap.get(supersetCommand).containsKey(subsetCommand))
				return inclusionMap.get(supersetCommand).get(subsetCommand);
		}
		else
			inclusionMap.put(supersetCommand, new HashMap<Command<TaxonIdentifier>, Command<Set<Inclusion>>>());
		final IncludeTaxa includeTaxa = new IncludeTaxa();
		includeTaxa.setDatasetCommand(taxonomyCommand);
		final CommandList<TaxonIdentifier> subsetsCommand = new CommandList<TaxonIdentifier>();
		subsetsCommand.getCommands().add(subsetCommand);
		includeTaxa.setSubsetsCommand(subsetsCommand);
		includeTaxa.setSupersetCommand(supersetCommand);
		return includeTaxa;
	}
	protected Command<Set<Inclusion>> createInclusionCommand(final Command<TaxonIdentifier> supersetCommand,
	        final Command<TaxonIdentifier> subsetCommand)
	{
		final IncludeTaxa includeTaxa = new IncludeTaxa();
		includeTaxa.setDatasetCommand(taxonomyCommand);
		final CommandList<TaxonIdentifier> subsetsCommand = new CommandList<TaxonIdentifier>();
		subsetsCommand.getCommands().add(subsetCommand);
		includeTaxa.setSubsetsCommand(subsetsCommand);
		includeTaxa.setSupersetCommand(supersetCommand);
		return includeTaxa;
	}
	private Command<TaxonIdentifier> defineName(final String name, final String rank, final double level)
	{
		if (nameMap.containsKey(name))
			return nameMap.get(name);
		final CreateZooUndefinedName nameCommand = new CreateZooUndefinedName(name);
		final RankDefine createDefinition = new RankDefine();
		createDefinition.setAuthorityCommand(redListCommand);
		createDefinition.setIdentifierCommand(nameCommand);
		createDefinition.setLevel(level);
		createDefinition.setRank(rank);
		nameMap.put(name, createDefinition);
		return createDefinition;
	}
	private Command<List<TaxonIdentifier>> getSpeciesGroupCommand(final String scientificName,
	        final Command<Taxon> taxonCommand)
	{
		final String[] names = scientificName.split(" ");
		final String superspeciesName = names[0] + " (" + names[1] + ")";
		final String subspeciesName = names[0] + " " + names[1] + " " + names[1];
		if (nameMap.containsKey(scientificName))
		{
			final CommandList<TaxonIdentifier> nameCommands = new CommandList<TaxonIdentifier>();
			nameCommands.add(nameMap.get(superspeciesName));
			nameCommands.add(nameMap.get(scientificName));
			nameCommands.add(nameMap.get(subspeciesName));
			return nameCommands;
		}
		final CreateZooSpeciesGroup createGroup = new CreateZooSpeciesGroup();
		createGroup.setBaseName(scientificName);
		createGroup.setTaxonCommand(taxonCommand);
		nameMap.put(superspeciesName, new ExtractElement<TaxonIdentifier>(createGroup, 0));
		nameMap.put(scientificName, new ExtractElement<TaxonIdentifier>(createGroup, 1));
		nameMap.put(subspeciesName, new ExtractElement<TaxonIdentifier>(createGroup, 2));
		return createGroup;
	}
	private Command<? extends Object> translateFamilyGroup(final Species species)
	{
		final CreateZooFamilyGroup createGroup = new CreateZooFamilyGroup();
		createGroup.setBaseName(species.familyName);
		if (isTypeGenus(species))
			createGroup.setTypeCommand(nameMap.get(species.genusName));
		return createGroup;
	}
	private Command<? extends Object> translateGenusGroup(final Species species)
	{
		final CreateZooGenusGroup createGroup = new CreateZooGenusGroup();
		createGroup.setBaseName(species.genusName);
		return createGroup;
	}
	final List<Command<? extends Object>> translateSpeciesGroup(final Species species) throws TranslationException
	{
		final List<Command<? extends Object>> commands = new ArrayList<Command<? extends Object>>();
		final Command<Taxon> speciesCommand = new CreateTaxon();
		commands.add(getSpeciesGroupCommand(species.scientificName, speciesCommand));
		commands.add(helper.processSpecies(species, speciesCommand));
		return commands;
	}
	public CommandList<?> translateToCommands(final Species species) throws TranslationException
	{
		final CommandList<Object> commands = new CommandList<Object>();
		commands.addAll(translateSpeciesGroup(species));
		commands.add(translateGenusGroup(species));
		commands.add(translateFamilyGroup(species));
		commands.addAll(translateUntypifiedNames(species));
		return commands;
	}
	private Collection<? extends Command<? extends Object>> translateUntypifiedNames(final Species species)
	{
		final List<Command<? extends Object>> commands = new ArrayList<Command<? extends Object>>();
		final Command<TaxonIdentifier> kingdomCommand = defineName(species.kingdomName, "kingdom", 7.0);
		final Command<TaxonIdentifier> phylumCommand = defineName(species.phylumName, "phylum", 6.0);
		final Command<TaxonIdentifier> classCommand = defineName(species.className, "class", 5.0);
		final Command<TaxonIdentifier> orderCommand = defineName(species.orderName, "order", 4.0);
		commands.add(kingdomCommand);
		commands.add(phylumCommand);
		commands.add(classCommand);
		commands.add(orderCommand);
		commands.add(createDefinitionInclusionCommand(kingdomCommand, phylumCommand));
		commands.add(createDefinitionInclusionCommand(phylumCommand, classCommand));
		commands.add(createDefinitionInclusionCommand(classCommand, orderCommand));
		commands.add(createDefinitionInclusionCommand(orderCommand, nameMap.get(species.familyName)));
		return commands;
	}
}
