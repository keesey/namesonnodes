package org.namesonnodes.fileformats.iucn.translators;

import java.util.HashMap;
import java.util.Map;
import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.fileformats.iucn.model.Species;

public final class RankCodesTranslator implements SpeciesTranslator
{
	protected static final SpeciesTranslator botanicTranslator = new BotanicTranslator();
	protected static final SpeciesTranslator zooTranslator = new ZooTranslator();
	protected static final Map<String, SpeciesTranslator> translatorMap = new HashMap<String, SpeciesTranslator>();
	static
	{
		translatorMap.put("PLANTAE", botanicTranslator);
		translatorMap.put("FUNGI", botanicTranslator);
		translatorMap.put("ANIMALIA", zooTranslator);
		translatorMap.put("PROTISTA:OCHROPHYTA", botanicTranslator);
	}
	protected static SpeciesTranslator determineTranslator(final Species species) throws TranslationException
	{
		String key = species.kingdomName;
		if (!translatorMap.containsKey(key))
		{
			key += ":" + species.phylumName;
			if (!translatorMap.containsKey(key))
				throw new TranslationException("Cannot determine rank-based code for species: "
				        + species.scientificName + ".");
		}
		return translatorMap.get(key);
	}
	public CommandList<? extends Object> translateToCommands(final Species species) throws TranslationException
	{
		return determineTranslator(species).translateToCommands(species);
	}
}
