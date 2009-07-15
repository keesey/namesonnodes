package org.namesonnodes.niso.sici;

import static org.namesonnodes.iso.isbn.ISBNUtil.RAW_ISBN_REGEX;
import static org.namesonnodes.iso.isbn.ISBNUtil.validateISBN;
import org.namesonnodes.iso.ISOException;
import org.namesonnodes.niso.NISOException;

public final class BICISchema extends Schema
{
	public static final Schema INSTANCE = new BICISchema();
	private BICISchema()
	{
		super();
	}
	@Override
	public String formatStandardNumber(final String standardNumber)
	{
		return standardNumber.replaceAll("-", "");
	}
	@Override
	public String getName()
	{
		return "BICI";
	}
	@Override
	public String getURIPrefix()
	{
		return "urn:bici:";
	}
	@Override
	public boolean matchesSource(final String source)
	{
		final int pos = source.indexOf('(');
		if (pos <= 0)
			return false;
		return formatStandardNumber(source.substring(0, pos)).matches(RAW_ISBN_REGEX);
	}
	@Override
	public void verifyStandardNumber(final String standardNumber) throws NISOException
	{
		try
		{
			validateISBN(standardNumber);
		}
		catch (final ISOException ex)
		{
			throw new NISOException(ex);
		}
	}
}
