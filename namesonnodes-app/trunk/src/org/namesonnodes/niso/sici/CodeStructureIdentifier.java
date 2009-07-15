package org.namesonnodes.niso.sici;

import static org.namesonnodes.niso.sici.Requirement.ALWAYS;
import static org.namesonnodes.niso.sici.Requirement.NEVER;
import static org.namesonnodes.niso.sici.Requirement.OPTIONAL;
import java.util.HashMap;
import java.util.Map;

public final class CodeStructureIdentifier
{
	public static final Map<Integer, CodeStructureIdentifier> INSTANCE_MAP = new HashMap<Integer, CodeStructureIdentifier>();
	public static final CodeStructureIdentifier CSI1 = new CodeStructureIdentifier(1, ALWAYS, OPTIONAL, NEVER, NEVER,
	        NEVER);
	public static final CodeStructureIdentifier CSI2 = new CodeStructureIdentifier(2, ALWAYS, OPTIONAL, ALWAYS, ALWAYS,
	        NEVER);
	public static final CodeStructureIdentifier CSI3 = new CodeStructureIdentifier(3, OPTIONAL, OPTIONAL, OPTIONAL,
	        OPTIONAL, ALWAYS);
	private final Requirement chronology;
	private final Requirement enumeration;
	private final Requirement localNumber;
	private final Requirement location;
	private final int number;
	private final Requirement titleCode;
	private CodeStructureIdentifier(final int number, final Requirement chronology, final Requirement enumeration,
	        final Requirement location, final Requirement titleCode, final Requirement localNumber)
	{
		super();
		this.number = number;
		this.chronology = chronology;
		this.enumeration = enumeration;
		this.location = location;
		this.titleCode = titleCode;
		this.localNumber = localNumber;
		INSTANCE_MAP.put(number, this);
	}
	public final Requirement getChronology()
	{
		return chronology;
	}
	public final Requirement getEnumeration()
	{
		return enumeration;
	}
	public final Requirement getLocalNumber()
	{
		return localNumber;
	}
	public final Requirement getLocation()
	{
		return location;
	}
	public final int getNumber()
	{
		return number;
	}
	public final Requirement getTitleCode()
	{
		return titleCode;
	}
	@Override
	public String toString()
	{
		return "CSI-" + number;
	}
}
