package org.namesonnodes.niso.sici;

import static org.namesonnodes.niso.sici.Requirement.NEVER;
import static org.namesonnodes.utils.CollectionUtil.join;
import static org.namesonnodes.utils.URIUtil.unescape;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.namesonnodes.niso.NISOException;

public final class SICI
{
	protected static final Map<Integer, Character> CHECK_CHARACTER_INVERSE_MAP = new HashMap<Integer, Character>();
	protected static final Map<Character, Integer> CHECK_CHARACTER_MAP = new HashMap<Character, Integer>();
	public static final String ENUMERATION_PIECE_REGEX = "^[A-Z0-9]+$";
	public static final String LOCAL_NUMBER_REGEX = "^[!-9?-~;=]+$";
	public static final String LOCATION_REGEX = "^[!-9?-~;=]+$";
	public static final String MFI_REGEX = "^[A-Z]{2}$";
	public static final Schema[] SCHEMAS = { SICISchema.INSTANCE, BICISchema.INSTANCE };
	public static final String TITLE_CODE_REGEX = "^[A-Z]{1,6}$";
	static
	{
		addCheckCharacter('0', 0);
		addCheckCharacter('1', 1);
		addCheckCharacter('2', 2);
		addCheckCharacter('3', 3);
		addCheckCharacter('4', 4);
		addCheckCharacter('5', 5);
		addCheckCharacter('6', 6);
		addCheckCharacter('7', 7);
		addCheckCharacter('8', 8);
		addCheckCharacter('9', 9);
		addCheckCharacter('A', 10);
		addCheckCharacter('B', 11);
		addCheckCharacter('C', 12);
		addCheckCharacter('D', 13);
		addCheckCharacter('E', 14);
		addCheckCharacter('F', 15);
		addCheckCharacter('G', 16);
		addCheckCharacter('H', 17);
		addCheckCharacter('I', 18);
		addCheckCharacter('J', 19);
		addCheckCharacter('K', 20);
		addCheckCharacter('L', 21);
		addCheckCharacter('M', 22);
		addCheckCharacter('N', 23);
		addCheckCharacter('O', 24);
		addCheckCharacter('P', 25);
		addCheckCharacter('Q', 26);
		addCheckCharacter('R', 27);
		addCheckCharacter('S', 28);
		addCheckCharacter('T', 29);
		addCheckCharacter('U', 30);
		addCheckCharacter('V', 31);
		addCheckCharacter('W', 32);
		addCheckCharacter('X', 33);
		addCheckCharacter('Y', 34);
		addCheckCharacter('Z', 35);
		addCheckCharacter('#', 36);
	}
	protected static void addCheckCharacter(final char c, final int i)
	{
		SICI.CHECK_CHARACTER_MAP.put(c, i);
		SICI.CHECK_CHARACTER_INVERSE_MAP.put(i, c);
	}
	protected static char findCheckCharacter(final String uncheckedSICI)
	{
		final List<Integer> numbers = new ArrayList<Integer>();
		final int n = uncheckedSICI.length();
		for (int i = 0; i < n; ++i)
		{
			final char c = uncheckedSICI.charAt(i);
			if (SICI.CHECK_CHARACTER_MAP.containsKey(c))
				numbers.add(SICI.CHECK_CHARACTER_MAP.get(c));
			else
				numbers.add(36);
		}
		int sum = 0;
		for (int i = numbers.size() - 1; i >= 0; i -= 2)
			sum += numbers.get(i);
		sum *= 3;
		for (int i = numbers.size() - 2; i >= 0; i -= 2)
			sum += numbers.get(i);
		sum %= 37;
		return SICI.CHECK_CHARACTER_INVERSE_MAP.get(sum == 0 ? 9 : 37 - sum);
	}
	protected static Schema findSchemaForSource(final String source)
	{
		for (final Schema schema : SCHEMAS)
			if (source.startsWith(schema.getURIPrefix()) || schema.matchesSource(source))
				return schema;
		return null;
	}
	protected static Schema findSchemaForURI(final String uri)
	{
		for (final Schema schema : SCHEMAS)
			if (uri.startsWith(schema.getURIPrefix()))
				return schema;
		return null;
	}
	protected final List<ChronologyDate> chronology = new ArrayList<ChronologyDate>();
	protected CodeStructureIdentifier codeStructureIdentifier;
	protected int derivativePartIdentifier;
	protected final List<List<String>> enumerationValues = new ArrayList<List<String>>();
	protected boolean index = false;
	protected String localNumber = "";
	protected String location = "";
	protected String mediumFormatIdentifier = "";
	private Schema schema = SICISchema.INSTANCE;
	private String standardNumber = "";
	protected int standardVersionNumber;
	protected boolean supplement = false;
	protected String titleCode = "";
	public SICI()
	{
		super();
	}
	public SICI(final Schema schema)
	{
		super();
		this.schema = schema;
	}
	public SICI(final String source) throws NISOException
	{
		super();
		schema = findSchemaForSource(source);
		if (schema == null)
			throw new NISOException("Cannot determine schema: '" + source + "'.");
		if (source.startsWith(schema.getURIPrefix()))
			readURI(source);
		else
			readSource(source);
	}
	public final char getCheckCharacter()
	{
		try
		{
			return findCheckCharacter(toUncheckedIdentifierString());
		}
		catch (final NISOException ex)
		{
			return 0;
		}
	}
	public final List<ChronologyDate> getChronology()
	{
		return chronology;
	}
	public final CodeStructureIdentifier getCodeStructureIdentifier()
	{
		return codeStructureIdentifier;
	}
	public final int getDerivativePartIdentifier()
	{
		return derivativePartIdentifier;
	}
	public final List<List<String>> getEnumerationValues()
	{
		return enumerationValues;
	}
	public final boolean getIndex()
	{
		return index;
	}
	public final String getLocalNumber()
	{
		return localNumber;
	}
	public final String getLocation()
	{
		return location;
	}
	public final String getMediumFormatIdentifier()
	{
		return mediumFormatIdentifier;
	}
	public final Schema getSchema()
	{
		return schema;
	}
	public final String getStandardNumber()
	{
		return standardNumber;
	}
	public final int getStandardVersionNumber()
	{
		return standardVersionNumber;
	}
	public final boolean getSupplement()
	{
		return supplement;
	}
	public final String getTitleCode()
	{
		return titleCode;
	}
	protected void readChronology(final String source) throws NISOException
	{
		chronology.clear();
		if (source.length() == 0)
			return;
		final String[] chronologyStrings = source.split("/");
		ChronologyDate lastDate = null;
		for (final String chronologyString : chronologyStrings)
			chronology.add(lastDate = new ChronologyDate(chronologyString, lastDate));
	}
	protected void readCodeStructureIdentifier(final String source) throws NISOException
	{
		codeStructureIdentifier = CodeStructureIdentifier.INSTANCE_MAP.get(new Integer(source));
		if (codeStructureIdentifier == null)
			throw new NISOException("Invalid code structure identifier: " + source);
	}
	protected void readContribution(final String source) throws NISOException
	{
		if (source == "")
			return;
		final String[] parts = source.split(":");
		final int n = parts.length;
		readLocation(n >= 1 ? parts[0] : "");
		readTitleCode(n >= 2 ? parts[1] : "");
		readLocalNumber(n >= 3 ? parts[2] : "");
	}
	protected void readControl(final String source) throws NISOException
	{
		final String[] mainParts = source.split(";");
		if (mainParts.length != 2)
			throw new NISOException("Invalid control segment.");
		final String[] firstParts = mainParts[0].split("\\.");
		if (firstParts.length != 3)
			throw new NISOException("Invalid control segment.");
		final String[] lastParts = mainParts[1].split("-");
		if (lastParts.length != 2)
			throw new NISOException("Invalid control segment.");
		if (lastParts[1].length() != 1)
			throw new NISOException("Multiple check characters.");
		readCodeStructureIdentifier(firstParts[0]);
		readDerivativePartIdentifier(firstParts[1]);
		readMediumFormatIdentifier(firstParts[2]);
		readStandardVersionNumber(lastParts[0]);
	}
	protected void readDerivativePartIdentifier(final String source) throws NISOException
	{
		derivativePartIdentifier = new Integer(source);
	}
	protected void readEnumeration(final String source) throws NISOException
	{
		enumerationValues.clear();
		if (source == "+")
		{
			index = false;
			supplement = true;
			return;
		}
		if (source == "*")
		{
			index = true;
			supplement = false;
			return;
		}
		if (source == "")
		{
			index = false;
			supplement = false;
			return;
		}
		String[] parts;
		final char c = source.charAt(source.length() - 1);
		if (c == '+')
		{
			index = false;
			supplement = true;
			parts = source.substring(0, source.length() - 1).split(":");
		}
		else if (c == '*')
		{
			index = false;
			supplement = true;
			parts = source.substring(0, source.length() - 1).split(":");
		}
		else
		{
			supplement = false;
			parts = source.split(":");
		}
		for (final String part : parts)
		{
			final List<String> value = new ArrayList<String>();
			for (final String subpart : part.split("/"))
				value.add(subpart);
			enumerationValues.add(value);
		}
	}
	protected void readItem(final String source) throws NISOException
	{
		final String[] piecesA = source.split("\\(");
		if (piecesA.length != 2)
			throw new NISOException("Invalid or missing chronology segment.");
		if (piecesA[1].indexOf(')') < 0)
			throw new NISOException("Invalid or missing chronology segment.");
		final String[] piecesB = piecesA[1].split("\\)");
		readStandardNumber(piecesA[0]);
		readChronology(piecesB[0]);
		readEnumeration(piecesB.length == 2 ? piecesB[1] : "");
	}
	protected void readLocalNumber(final String source)
	{
		localNumber = source;
	}
	protected void readLocation(final String source)
	{
		location = source;
	}
	protected void readMediumFormatIdentifier(final String source) throws NISOException
	{
		mediumFormatIdentifier = source;
	}
	public void readSource(final String source) throws NISOException
	{
		if (findCheckCharacter(source.substring(0, source.length() - 1)) != source.charAt(source.length() - 1))
			throw new NISOException("Invalid check character.");
		final String[] segmentsA = source.split("<");
		if (segmentsA.length != 2)
			throw new NISOException("Invalid or missing contribution segment.");
		final String[] segmentsB = segmentsA[1].split(">");
		if (segmentsB.length < 2)
			throw new NISOException("Invalid or missing contribution segment.");
		readItem(segmentsA[0]);
		readContribution(segmentsB[0]);
		readControl(segmentsB[1]);
		verify();
	}
	protected void readStandardNumber(final String source) throws NISOException
	{
		standardNumber = schema == null ? source : schema.formatStandardNumber(source);
	}
	protected void readStandardVersionNumber(final String source) throws NISOException
	{
		standardVersionNumber = new Integer(source);
	}
	protected void readTitleCode(final String source)
	{
		titleCode = source;
	}
	public final void readURI(final String uri) throws NISOException
	{
		if (schema == null)
		{
			schema = findSchemaForURI(uri);
			if (schema == null)
				throw new NISOException("Cannot determine schema: '" + uri + "'.");
		}
		readSource(unescape(uri.substring(schema.getURIPrefix().length())));
	}
	public final void setChronology(final List<ChronologyDate> chronology)
	{
		this.chronology.clear();
		if (chronology != null)
			this.chronology.addAll(chronology);
	}
	public final void setCodeStructureIdentifier(final CodeStructureIdentifier codeStructureIdentifier)
	{
		this.codeStructureIdentifier = codeStructureIdentifier;
	}
	public final void setDerivativePartIdentifier(final int derivatePartIdentifier)
	{
		this.derivativePartIdentifier = derivatePartIdentifier;
	}
	public final void setEnumerationValues(final List<List<String>> enumeration)
	{
		this.enumerationValues.clear();
		if (enumeration != null)
			this.enumerationValues.addAll(enumeration);
	}
	public final void setIndex(final boolean index)
	{
		this.index = index;
	}
	public final void setLocalNumber(final String localNumber)
	{
		this.localNumber = localNumber == null ? "" : localNumber;
	}
	public final void setLocation(final String location)
	{
		this.location = location == null ? "" : location;
	}
	public final void setMediumFormatIdentifier(final String mediumFormatIdentifier)
	{
		this.mediumFormatIdentifier = mediumFormatIdentifier == null ? "" : mediumFormatIdentifier;
	}
	public final void setSchema(final Schema schema)
	{
		this.schema = schema;
		if (schema != null && standardNumber.length() > 0)
			standardNumber = schema.formatStandardNumber(standardNumber);
	}
	public final void setStandardNumber(final String number)
	{
		standardNumber = number == null ? "" : number;
		if (schema != null && standardNumber.length() > 0)
			standardNumber = schema.formatStandardNumber(standardNumber);
	}
	public final void setStandardVersionNumber(final int standardVersionNumber)
	{
		this.standardVersionNumber = standardVersionNumber;
	}
	public final void setSupplement(final boolean supplement)
	{
		this.supplement = supplement;
	}
	public final void setTitle(final String title)
	{
		titleCode = "";
		if (title != null && title.length() != 0)
		{
			final String[] words = title.toUpperCase().split("\\s+");
			for (String word : words)
			{
				word = word.replaceAll("[^A-Z]", "");
				if (word.length() != 0)
				{
					titleCode += word.charAt(0);
					if (titleCode.length() >= 6)
						return;
				}
			}
		}
	}
	public final void setTitleCode(final String titleCode)
	{
		this.titleCode = titleCode == null ? "" : titleCode;
	}
	protected String toChronologyString()
	{
		String s = "";
		ChronologyDate previous = null;
		for (final ChronologyDate date : chronology)
		{
			s += date.toChronologyString(previous);
			if (previous != null)
				s += "/";
			previous = date;
		}
		return s;
	}
	protected String toContributionString()
	{
		final List<String> parts = new ArrayList<String>();
		if (codeStructureIdentifier.getLocation() != NEVER)
			parts.add(location);
		if (codeStructureIdentifier.getTitleCode() != NEVER)
			parts.add(titleCode);
		if (codeStructureIdentifier.getLocalNumber() != NEVER)
			parts.add(localNumber);
		return join(parts, ":");
	}
	protected String toEnumerationString()
	{
		String s = "";
		boolean first = true;
		for (final List<String> value : enumerationValues)
		{
			if (first)
				first = false;
			else
				s += ":";
			s += join(value, "/");
		}
		if (index)
			s += "*";
		else if (supplement)
			s += "+";
		return s;
	}
	public final String toIdentifierString() throws NISOException
	{
		final String unchecked = toUncheckedIdentifierString();
		return unchecked + findCheckCharacter(unchecked);
	}
	protected String toItemString()
	{
		return standardNumber + "(" + toChronologyString() + ")" + toEnumerationString();
	}
	protected String toUncheckedControlString()
	{
		return Integer.toString(codeStructureIdentifier.getNumber()) + "." + derivativePartIdentifier + "."
		        + mediumFormatIdentifier + ";" + standardVersionNumber + "-";
	}
	protected String toUncheckedIdentifierString() throws NISOException
	{
		verify();
		return toItemString() + "<" + toContributionString() + ">" + toUncheckedControlString();
	}
	public final String toURI() throws NISOException, UnsupportedEncodingException
	{
		if (schema == null)
			throw new NISOException("Cannot translate to URI without setting schema.");
		return schema.getURIPrefix() + toIdentifierString().replace("<", "%3C").replace(">", "%3E");
	}
	public void verify() throws NISOException
	{
		if (schema == null)
			throw new NISOException("No schema set.");
		schema.verifyStandardNumber(standardNumber);
		verifyCSI();
		verifyChronology();
		verifyEnumeration();
		verifyLocation();
		verifyTitleCode();
		verifyLocalNumber();
		verifyDPI();
		verifyMFI();
		verifySVN();
	}
	protected final void verifyChronology() throws NISOException
	{
		switch (codeStructureIdentifier.getChronology())
		{
			case ALWAYS:
			{
				if (chronology.isEmpty())
					throw new NISOException("Chronology is required.");
			}
			case OPTIONAL:
			{
				if (chronology.size() > 2)
					throw new NISOException("Too many dates in chronology.");
				break;
			}
			case NEVER:
			{
				if (!chronology.isEmpty())
					throw new NISOException("Chronology should not be present.");
			}
		}
	}
	protected final void verifyCSI() throws NISOException
	{
		if (codeStructureIdentifier == null)
			throw new NISOException("No code structure identifier.");
	}
	protected void verifyDPI() throws NISOException
	{
		if (derivativePartIdentifier < 0)
			throw new NISOException("Invalid derivative part identifier: " + derivativePartIdentifier + ".");
	}
	protected void verifyEnumeration() throws NISOException
	{
		switch (codeStructureIdentifier.getEnumeration())
		{
			case ALWAYS:
			{
				if (enumerationValues.isEmpty() && !supplement && !index)
					throw new NISOException("Enumeration is required.");
			}
			case OPTIONAL:
			{
				for (final List<String> value : enumerationValues)
				{
					if (value.isEmpty())
						throw new NISOException("Empty enumeration value.");
					if (value.size() > 2)
						throw new NISOException("Too many enumeration values in range: " + value + ".");
					for (final String piece : value)
						if (!piece.matches(ENUMERATION_PIECE_REGEX))
							throw new NISOException("Invalid enumeration piece: '" + piece + "'.");
				}
				break;
			}
			case NEVER:
			{
				if (!enumerationValues.isEmpty() || supplement || index)
					throw new NISOException("Enumeration should not be present.");
			}
		}
	}
	protected void verifyLocalNumber() throws NISOException
	{
		switch (codeStructureIdentifier.getLocalNumber())
		{
			case ALWAYS:
			{
				if (localNumber.length() == 0)
					throw new NISOException("Local number is required.");
			}
			case OPTIONAL:
			{
				if (localNumber.length() == 0)
					return;
				if (!localNumber.matches(LOCAL_NUMBER_REGEX))
					throw new NISOException("Invalid local number: '" + localNumber + ".");
				break;
			}
			case NEVER:
			{
				if (localNumber.length() != 0 && schema != BICISchema.INSTANCE)
					throw new NISOException("Local number should not be present.");
			}
		}
	}
	protected final void verifyLocation() throws NISOException
	{
		switch (codeStructureIdentifier.getLocation())
		{
			case ALWAYS:
			{
				if (location.length() == 0)
					throw new NISOException("Location is required.");
			}
			case OPTIONAL:
			{
				if (location.length() == 0)
					return;
				if (!location.matches(LOCATION_REGEX))
					throw new NISOException("Invalid location: '" + location + ".");
				break;
			}
			case NEVER:
			{
				if (location.length() != 0)
					throw new NISOException("Location should not be present.");
			}
		}
	}
	protected final void verifyMFI() throws NISOException
	{
		if (!mediumFormatIdentifier.matches(MFI_REGEX))
			throw new NISOException("Invalid medium format identifier: '" + mediumFormatIdentifier + "'.");
	}
	protected void verifySVN() throws NISOException
	{
		if (standardVersionNumber != 1 && standardVersionNumber != 2)
			throw new NISOException("Unsupported " + (schema == null ? "SICI" : schema.getName()) + " version: "
			        + standardVersionNumber + ".");
	}
	protected final void verifyTitleCode() throws NISOException
	{
		switch (codeStructureIdentifier.getTitleCode())
		{
			case ALWAYS:
			{
				if (titleCode.length() == 0)
					throw new NISOException("Title code is required.");
			}
			case OPTIONAL:
			{
				if (titleCode.length() == 0)
					return;
				if (!titleCode.matches(TITLE_CODE_REGEX))
					throw new NISOException("Invalid title code: '" + titleCode + "'.");
				break;
			}
			case NEVER:
			{
				if (titleCode.length() != 0)
					throw new NISOException("Title code should not be present.");
			}
		}
	}
}
