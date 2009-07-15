package org.namesonnodes.niso.sici;

import org.namesonnodes.niso.NISOException;

public abstract class Schema
{
	public abstract String formatStandardNumber(final String standardNumber);
	public abstract String getName();
	public abstract String getURIPrefix();
	public abstract boolean matchesSource(final String source);
	public abstract void verifyStandardNumber(final String standardNumber) throws NISOException;
}
