package org.namesonnodes.iso.issn;

import org.namesonnodes.iso.ISOException;

public final class ISSNUtil
{
	public static final String ISSN_REGEX = "^[0-9]{4}-[0-9]{3}[0-9X]";
	public static void validateISSN(final String issn) throws ISOException
	{
		if (!issn.matches(ISSN_REGEX))
			throw new ISOException("Invalid ISSN number: '" + issn + "'.");
		final int[] digits = new int[7];
		for (int i = 0; i < 7; ++i)
		{
			final int pos = i >= 4 ? i + 1 : i;
			digits[i] = new Integer(issn.substring(pos, pos + 1));
		}
		final int check = 11 - (digits[0] * 8 + digits[1] * 7 + digits[2] * 6 + digits[3] * 5 + digits[4] * 4
		        + digits[5] * 3 + digits[6] * 2) % 11;
		final char checkChar = check == 11 ? '0' : check == 10 ? 'X' : Integer.toString(check).charAt(0);
		if (issn.charAt(issn.length() - 1) != checkChar)
			throw new ISOException("ISSN check digit (" + checkChar + ") does not match ISSN ('" + issn + "').");
	}
	private ISSNUtil()
	{
		super();
	}
}
