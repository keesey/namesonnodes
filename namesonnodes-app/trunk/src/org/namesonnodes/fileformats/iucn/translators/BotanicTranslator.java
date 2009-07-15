package org.namesonnodes.fileformats.iucn.translators;

import static org.namesonnodes.fileformats.iucn.translators.IUCNRedList.ASSESSMENTS_QNAME;
import static org.namesonnodes.fileformats.iucn.translators.IUCNRedList.TAXONOMY_QNAME;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.commands.collections.CommandSet;
import org.namesonnodes.commands.identity.ExtractTaxon;
import org.namesonnodes.commands.nomenclature.RankDefine;
import org.namesonnodes.commands.nomenclature.botanic.CreateBotanicGenusName;
import org.namesonnodes.commands.nomenclature.botanic.CreateBotanicSpeciesName;
import org.namesonnodes.commands.nomenclature.botanic.CreateBotanicSupragenericName;
import org.namesonnodes.commands.nomenclature.botanic.CreateBotanicUndefinedName;
import org.namesonnodes.commands.relate.IncludeTaxa;
import org.namesonnodes.commands.resolve.ResolveDataset;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.fileformats.iucn.model.Species;

public final class BotanicTranslator implements SpeciesTranslator
{
	protected final Command<Dataset> assessmentsCommand = new ResolveDataset(ASSESSMENTS_QNAME);
	protected final Command<AuthorityIdentifier> redListCommand = new ResolveURI(IUCNRedList.URI);
	protected final Command<Dataset> taxonomyCommand = new ResolveDataset(TAXONOMY_QNAME);
	private final Map<String, Command<TaxonIdentifier>> nameMap = new HashMap<String, Command<TaxonIdentifier>>();
	protected final RedListTranslationHelper helper = new RedListTranslationHelper(redListCommand, taxonomyCommand,
	        assessmentsCommand);
	private List<Command<Set<Inclusion>>> createInclusions(final List<Command<TaxonIdentifier>> nameCommands)
	{
		final List<Command<Set<Inclusion>>> inclusions = new ArrayList<Command<Set<Inclusion>>>();
		final int n = nameCommands.size() - 1;
		for (int i = 0; i < n; ++i)
		{
			final IncludeTaxa includeTaxa = new IncludeTaxa();
			includeTaxa.setDatasetCommand(taxonomyCommand);
			includeTaxa.setSupersetCommand(nameCommands.get(i + 1));
			final CommandSet<TaxonIdentifier> subsetCommands = new CommandSet<TaxonIdentifier>();
			subsetCommands.add(nameCommands.get(i));
			includeTaxa.setSubsetsCommand(subsetCommands);
			inclusions.add(includeTaxa);
		}
		return inclusions;
	}
	private List<Command<TaxonIdentifier>> createNames(final Species species)
	{
		final List<Command<TaxonIdentifier>> commands = new ArrayList<Command<TaxonIdentifier>>();
		commands.add(getSpeciesName(species.scientificName));
		commands.add(getGenusName(species.genusName));
		commands.add(getSupragenericName(species.familyName, species.genusName));
		commands.add(getSupragenericName(species.orderName, species.genusName));
		commands.add(getSupragenericName(species.className, species.genusName));
		commands.add(getSupragenericName(species.phylumName, species.genusName));
		commands.add(getKingdomName(species.kingdomName));
		return commands;
	}
	private Command<TaxonIdentifier> getGenusName(final String name)
	{
		if (nameMap.containsKey(name))
			return nameMap.get(name);
		final CreateBotanicGenusName createName = new CreateBotanicGenusName();
		createName.setName(name);
		nameMap.put(name, createName);
		return createName;
	}
	private Command<TaxonIdentifier> getKingdomName(final String name)
	{
		if (nameMap.containsKey(name))
			return nameMap.get(name);
		final CreateBotanicUndefinedName createName = new CreateBotanicUndefinedName();
		createName.setName(name);
		final RankDefine rankDefine = new RankDefine();
		rankDefine.setAuthorityCommand(redListCommand);
		rankDefine.setIdentifierCommand(createName);
		rankDefine.setLevel(7.0);
		rankDefine.setRank("kingdom");
		return rankDefine;
	}
	private Command<TaxonIdentifier> getSpeciesName(final String name)
	{
		if (nameMap.containsKey(name))
			return nameMap.get(name);
		final CreateBotanicSpeciesName createName = new CreateBotanicSpeciesName();
		createName.setName(name);
		nameMap.put(name, createName);
		return createName;
	}
	private Command<TaxonIdentifier> getSupragenericName(final String name, final String typeGenusName)
	{
		if (nameMap.containsKey(name))
			return nameMap.get(name);
		final CreateBotanicSupragenericName createName = new CreateBotanicSupragenericName();
		createName.setName(name);
		if (typeGenusName != null)
			createName.setTypeCommand(getGenusName(typeGenusName));
		nameMap.put(name, createName);
		return createName;
	}
	public CommandList<? extends Object> translateToCommands(final Species species) throws TranslationException
	{
		final CommandList<Object> commands = new CommandList<Object>();
		final List<Command<TaxonIdentifier>> names = createNames(species);
		final Command<TaxonIdentifier> speciesName = names.get(names.size() - 1);
		final Command<Taxon> speciesCommand = new ExtractTaxon(speciesName);
		commands.addAll(names);
		commands.add(helper.processSpecies(species, speciesCommand));
		commands.addAll(createInclusions(names));
		return commands;
	}
}
