package org.namesonnodes.commands.nomenclature.zoo;

import java.util.HashMap;
import java.util.Map;

public final class ZoologicalRank
{
	private static final Map<String, String> CANONICAL_NAMES = new HashMap<String, String>();
	private static final Map<String, Double> LEVEL_MAP = new HashMap<String, Double>();
	static
	{
		LEVEL_MAP.put("suprafamilia", 3.05);
		LEVEL_MAP.put("familia", 3.0);
		LEVEL_MAP.put("subfamilia", 2.95);
		LEVEL_MAP.put("tribus", 2.8);
		LEVEL_MAP.put("subtribus", 2.75);
		LEVEL_MAP.put("genus", 2.0);
		LEVEL_MAP.put("subgenus", 1.95);
		LEVEL_MAP.put("superspecies", 1.05);
		LEVEL_MAP.put("species", 1.0);
		LEVEL_MAP.put("subspecies", 0.95);
		for (final String rank : LEVEL_MAP.keySet())
			CANONICAL_NAMES.put(rank, rank);
		CANONICAL_NAMES.put("superfamily", "suprafamilia");
		CANONICAL_NAMES.put("family", "familia");
		CANONICAL_NAMES.put("subfamily", "subfamilia");
		CANONICAL_NAMES.put("tribe", "tribus");
		CANONICAL_NAMES.put("subtribe", "subtribus");
	}
	public static String getCanonicalName(final String rankName)
	{
		return CANONICAL_NAMES.get(rankName);
	}
	public static final double getLevel(final String canonicalRankName)
	{
		return LEVEL_MAP.get(canonicalRankName);
	}
}
