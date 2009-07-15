package org.namesonnodes.fileformats.iucn.model;

import java.util.HashSet;
import java.util.Set;

public final class Species
{
	protected static final String capitalize(final String name)
	{
		return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
	}
	protected static final String formatUninomen(final String name)
	{
		return capitalize(name.replaceAll("[^A-Za-z]", ""));
	}
	public Assessment assessment;
	public String authority;
	public String className;
	public final Set<CommonName> commonNames = new HashSet<CommonName>();
	public String familyName;
	public String genusName;
	public int id;
	public String kingdomName;
	public String orderName;
	public String phylumName;
	public String scientificName;
	public String speciesName;
	public final Set<Synonym> synonyms = new HashSet<Synonym>();
	public void formatNames()
	{
		kingdomName = formatUninomen(kingdomName);
		phylumName = formatUninomen(phylumName);
		className = formatUninomen(className);
		orderName = formatUninomen(orderName);
		familyName = formatUninomen(familyName);
		genusName = formatUninomen(genusName);
	}
}
