package org.namesonnodes.fileformats.iucn.model;

import java.util.HashMap;
import java.util.Map;

public final class Category implements Comparable<Category>
{
	private static final Map<String, Category> CODE_MAP = new HashMap<String, Category>();
	public static final Category CR = new Category("CR", "Critically Endangered", true, true, true, 2);
	public static final Category DD = new Category("DD", "Data Deficient", true, false, false, 7);
	public static final Category EN = new Category("EN", "Endangered", true, true, true, 3);
	public static final Category EW = new Category("EW", "Extinct In The Wild", true, true, true, 1);
	public static final Category EX = new Category("EX", "Extinct", true, true, false, 0);
	public static final Category LC = new Category("LC", "Least Concern", true, true, false, 6);
	public static final Category NE = new Category("NE", "Not Evaluated", false, false, false, 8);
	public static final Category NT = new Category("NT", "Near Threatened", true, true, false, 5);
	public static final Category VU = new Category("VU", "Vulnerable", true, true, true, 4);
	public static final Category[] INSTANCES = { EX, EW, CR, EN, VU, NT, LC, DD, NE };
	public static Category getByCode(final String code)
	{
		return CODE_MAP.get(code);
	}
	private final boolean adequateData;
	private final String code;
	private final boolean evaluated;
	private final String name;
	private final int order;
	private final boolean threatened;
	private Category(final String code, final String name, final boolean evaluated, final boolean adequateData,
	        final boolean threatened, final int order)
	{
		super();
		this.code = code;
		this.name = name;
		this.evaluated = evaluated;
		this.adequateData = adequateData;
		this.threatened = threatened;
		this.order = order;
		CODE_MAP.put(code, this);
	}
	public int compareTo(final Category o)
	{
		if (o == null)
			return 1;
		return order - o.order;
	}
	public final String getCode()
	{
		return code;
	}
	public final String getName()
	{
		return name;
	}
	public final boolean isAdequateData()
	{
		return adequateData;
	}
	public final boolean isEvaluated()
	{
		return evaluated;
	}
	public final boolean isThreatened()
	{
		return evaluated && threatened;
	}
}
