package org.namesonnodes.fileformats.iucn.model;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class Assessment
{
	public static final String AUTHORITY_URI = "urn:isbn:2831706335";
	public static final Map<Integer, Map<Category, Assessment>> INSTANCE_MAP = new HashMap<Integer, Map<Category, Assessment>>();
	public static final String VERSION = "3.1";
	public static final int[] YEARS = { 2002, 2003, 2004, 2006, 2007, 2008 };
	static
	{
		for (final int year : YEARS)
		{
			final Map<Category, Assessment> categoryMap = new HashMap<Category, Assessment>();
			INSTANCE_MAP.put(year, categoryMap);
			for (final Category category : Category.INSTANCES)
				categoryMap.put(category, new Assessment(year, category));
		}
	}
	private Command<TaxonIdentifier> _command;
	private Set<Command<TaxonIdentifier>> _commandsToDate;
	private final Category category;
	private final int year;
	private Assessment(final int year, final Category category)
	{
		super();
		this.year = year;
		this.category = category;
	}
	public Command<TaxonIdentifier> command()
	{
		if (_command == null)
			_command = new ResolveTaxonIdentifier(qName());
		return _command;
	}
	public Set<Command<TaxonIdentifier>> commandsToDate()
	{
		if (_commandsToDate == null)
		{
			_commandsToDate = new HashSet<Command<TaxonIdentifier>>();
			boolean on = false;
			for (final int year : YEARS)
			{
				if (!on && year == this.year)
					on = true;
				if (on)
					_commandsToDate.add(INSTANCE_MAP.get(year).get(category).command());
			}
		}
		return _commandsToDate;
	}
	public final Category getCategory()
	{
		return category;
	}
	public final int getYear()
	{
		return year;
	}
	public String localName()
	{
		return "categories:" + category.getCode() + ":" + year;
	}
	public String qName()
	{
		return AUTHORITY_URI + "::" + localName();
	}
}
