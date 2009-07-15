package org.namesonnodes.iso.isbn;

import org.namesonnodes.iso.ISOException;

public final class ISBNUtil
{
	public static final String RAW_ISBN_REGEX = "^([0-9]{9}[0-9X]|[0-9]{13})$";
	public static void validateISBN(final String isbn) throws ISOException
	{
		final String standardNumber = isbn.replaceAll("-", "");
		if (!standardNumber.matches(RAW_ISBN_REGEX))
			throw new ISOException("Invalid ISBN number: '" + standardNumber + "'.");
		final int n = standardNumber.length();
		final int[] digits = new int[n];
		for (int i = 0; i < n; ++i)
			digits[i] = new Integer(standardNumber.substring(i, i + 1));
		int check = 0;
		if (n == 10)
			check = 11 - (digits[0] * 10 + digits[1] * 9 + digits[2] * 8 + digits[3] * 7 + digits[4] * 6 + digits[5]
			        * 5 + digits[6] * 4 + digits[7] * 3 + digits[8] * 2) % 11;
		else
		{
			int factor = 1;
			for (int i = 0; i < 13; ++i)
			{
				check += digits[i] * factor;
				factor = factor == 1 ? 3 : 1;
			}
			check = 10 - check % 10;
		}
		final char checkChar = check == 10 ? 'X' : Integer.toString(check).charAt(0);
		if (standardNumber.charAt(standardNumber.length() - 1) != checkChar)
			throw new ISOException("ISBN check digit (" + checkChar + ") does not match ISBN ('" + isbn + "').");
	}
}
