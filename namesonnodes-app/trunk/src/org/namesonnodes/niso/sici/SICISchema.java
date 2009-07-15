package org.namesonnodes.niso.sici;

import static org.namesonnodes.iso.issn.ISSNUtil.ISSN_REGEX;
import static org.namesonnodes.iso.issn.ISSNUtil.validateISSN;
import org.namesonnodes.iso.ISOException;
import org.namesonnodes.niso.NISOException;

public final class SICISchema extends Schema
{
	public static final Schema INSTANCE = new SICISchema();
	private SICISchema()
	{
		super();
	}
	@Override
	public String formatStandardNumber(final String standardNumber)
	{
		return standardNumber;
	}
	@Override
	public String getName()
	{
		return "SICI";
	}
	@Override
	public String getURIPrefix()
	{
		return "urn:sici:";
	}
	@Override
	public boolean matchesSource(final String source)
	{
		final int pos = source.indexOf('(');
		if (pos <= 0)
			return false;
		return source.substring(0, pos).matches(ISSN_REGEX);
	}
	@Override
	public void verifyStandardNumber(final String standardNumber) throws NISOException
	{
		try
		{
			validateISSN(standardNumber);
		}
		catch (final ISOException ex)
		{
			throw new NISOException(ex);
		}
	}
}
