package org.namesonnodes.commands.nomenclature.botanic;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public final class BotanicalRank
{
	private static final Map<String, String> ABBRS = new HashMap<String, String>();
	private static final Map<String, String> CANONICAL_NAMES = new HashMap<String, String>();
	private static final Map<String, Double> LEVEL_MAP = new HashMap<String, Double>();
	private static final Map<String, String> PATTERNS = new HashMap<String, String>();
	static
	{
		LEVEL_MAP.put("divisio", 6.0);
		LEVEL_MAP.put("subdivisio", 5.95);
		LEVEL_MAP.put("classis", 5.0);
		LEVEL_MAP.put("subclassis", 4.95);
		LEVEL_MAP.put("ordo", 4.0);
		LEVEL_MAP.put("subordo", 3.95);
		LEVEL_MAP.put("familia", 3.0);
		LEVEL_MAP.put("subfamilia", 2.95);
		LEVEL_MAP.put("tribus", 2.8);
		LEVEL_MAP.put("subtribus", 2.75);
		LEVEL_MAP.put("genus", 2.0);
		LEVEL_MAP.put("subgenus", 1.95);
		LEVEL_MAP.put("sectio", 1.9);
		LEVEL_MAP.put("subsectio", 1.85);
		LEVEL_MAP.put("series", 1.8);
		LEVEL_MAP.put("subseries", 1.75);
		LEVEL_MAP.put("species", 1.0);
		LEVEL_MAP.put("subspecies", 0.95);
		LEVEL_MAP.put("varietas", 0.9);
		LEVEL_MAP.put("subvarietas", 0.85);
		LEVEL_MAP.put("forma", 0.8);
		LEVEL_MAP.put("subforma", 0.75);
		for (final String rank : LEVEL_MAP.keySet())
			CANONICAL_NAMES.put(rank, rank);
		CANONICAL_NAMES.put("division", "divisio");
		CANONICAL_NAMES.put("phylum", "divisio");
		CANONICAL_NAMES.put("subdivision", "subdivisio");
		CANONICAL_NAMES.put("subphylum", "subdivisio");
		CANONICAL_NAMES.put("class", "classis");
		CANONICAL_NAMES.put("subclass", "subclassis");
		CANONICAL_NAMES.put("order", "ordo");
		CANONICAL_NAMES.put("suborder", "subordo");
		CANONICAL_NAMES.put("family", "familia");
		CANONICAL_NAMES.put("subfamily", "subfamilia");
		CANONICAL_NAMES.put("tribe", "tribus");
		CANONICAL_NAMES.put("subtribe", "subtribus");
		CANONICAL_NAMES.put("section", "sectio");
		CANONICAL_NAMES.put("subsection", "subsectio");
		CANONICAL_NAMES.put("variety", "varietas");
		CANONICAL_NAMES.put("subvariety", "subvarietas");
		CANONICAL_NAMES.put("form", "forma");
		CANONICAL_NAMES.put("subform", "subforma");
		ABBRS.put("classis", "cl.");
		ABBRS.put("subclassis", "subcl.");
		ABBRS.put("ordo", "ord.");
		ABBRS.put("subordo", "subord.");
		ABBRS.put("familia", "fam.");
		ABBRS.put("subfamilia", "subfam.");
		ABBRS.put("tribus", "tr.");
		ABBRS.put("subtribus", "subtr.");
		ABBRS.put("genus", "gen.");
		ABBRS.put("subgenus", "subg.");
		ABBRS.put("sectio", "sect.");
		ABBRS.put("subsectio", "subsect.");
		ABBRS.put("series", "ser.");
		ABBRS.put("subseries", "subser.");
		ABBRS.put("species", "sp.");
		ABBRS.put("subspecies", "subsp.");
		ABBRS.put("varietas", "var.");
		ABBRS.put("subvarietas", "subvar.");
		ABBRS.put("forma", "f.");
		ABBRS.put("subforma", "subf.");
		PATTERNS.put("divisio", "^([A-Z][a-z]+)(omycota|ophyta)$");
		PATTERNS.put("subdivisio", "^([A-Z][a-z]+)(omycotina|ophytina)$");
		PATTERNS.put("classis", "^([A-Z][a-z]+)(omycetes|ophyceae|opsida)$");
		PATTERNS.put("subclassis", "^([A-Z][a-z]+)(ophycidae|omycetidae|idae)$");
		PATTERNS.put("ordo", "^([A-Z][a-z]+)(ales)$");
		PATTERNS.put("subordo", "^([A-Z][a-z]+)(ineae)$");
		PATTERNS.put("familia", "^([A-Z][a-z]+)(aceae)$");
		PATTERNS.put("subfamilia", "^([A-Z][a-z]+)(oideae)$");
		PATTERNS.put("tribus", "^([A-Z][a-z]+)(eae)$");
		PATTERNS.put("subtribus", "^([A-Z][a-z]+)(inae)$");
		PATTERNS.put("genus", "^([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("subgenus", "^([A-Z][a-z]+(-[a-z]{2,})?) subg\\. ([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("sectio", "^([A-Z][a-z]+(-[a-z]{2,})?) sect\\. ([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("subsectio", "^([A-Z][a-z]+(-[a-z]{2,})?) subsect\\. ([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("series", "^([A-Z][a-z]+(-[a-z]{2,})?) ser\\. ([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("subseries", "^([A-Z][a-z]+(-[a-z]{2,})?) subser\\. ([A-Z][a-z]+(-[a-z]{2,})?)$");
		PATTERNS.put("species", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,})$");
		PATTERNS.put("subspecies", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,}) subsp\\. ([a-z]{2,})$");
		PATTERNS.put("varietas", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,}) var\\. ([a-z]{2,})$");
		PATTERNS.put("subvarietas", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,}) subvar\\. ([a-z]{2,})$");
		PATTERNS.put("forma", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,}) f\\. ([a-z]{2,})$");
		PATTERNS.put("subforma", "^([A-Z][a-z]+(-[a-z]{2,})?) ([a-z]{2,}) subf\\. ([a-z]{2,})$");
	}
	public static String getAbbr(final String canonicalRankName)
	{
		return ABBRS.get(canonicalRankName);
	}
	public static String getCanonicalName(final String rankName)
	{
		return CANONICAL_NAMES.get(rankName);
	}
	public static final double getLevel(final String canonicalRankName)
	{
		return LEVEL_MAP.get(canonicalRankName);
	}
	public static final String getPattern(final String canonicalRankName)
	{
		return PATTERNS.get(canonicalRankName);
	}
	public static final String getRankNameFromTaxonName(final String taxonName)
	{
		final Set<String> rankNames = new HashSet<String>(PATTERNS.keySet());
		rankNames.remove("genus");
		for (final String rankName : rankNames)
			if (taxonName.matches(PATTERNS.get(rankName)))
				return rankName;
		if (taxonName.matches(PATTERNS.get("genus")))
			return "genus";
		return null;
	}
	private BotanicalRank()
	{
		super();
	}
}
