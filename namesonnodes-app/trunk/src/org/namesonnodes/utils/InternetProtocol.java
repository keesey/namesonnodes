package org.namesonnodes.utils;

import static flex.messaging.FlexContext.getHttpRequest;
import java.util.regex.PatternSyntaxException;

public final class InternetProtocol
{
	public static String currentIPAddress()
	{
		return getHttpRequest() == null ? "0.0.0.0" : getHttpRequest().getRemoteAddr();
	}
	public static boolean isValidAddress(final String addr)
	{
		if (addr == null || addr.length() == 0)
			return false;
		if (addr.indexOf('.') >= 0)
			return isValidIP4Address(addr);
		if (addr.indexOf(':') >= 0)
			return isValidIP6Address(addr);
		return false;
	}
	public static boolean isValidIP4Address(final String addr)
	{
		if (addr == null)
			return false;
		if (addr.length() < 7 || addr.length() > 15)
			return false;
		try
		{
			final String[] parts = addr.split("\\.");
			if (parts.length != 4)
				return false;
			for (byte i = 0; i < 4; ++i)
			{
				final String part = parts[i];
				if (!part.matches("\\d{1,3}"))
					return false;
				final int intPart = new Integer(part).intValue();
				if (intPart >= 256)
					return false;
			}
		}
		catch (final PatternSyntaxException ex)
		{
			return false;
		}
		return true;
	}
	public static boolean isValidIP6Address(final String addr)
	{
		if (addr == null)
			return false;
		final String[] parts = addr.split(":");
		if (parts.length < 3 || parts.length > 8)
			return false;
		boolean abridged = false;
		for (final String part : parts)
			if (part.length() == 0)
			{
				if (abridged)
					return false;
				abridged = true;
			}
			else if (!part.matches("^[a-f0-9]{1,4}$"))
				return false;
		return abridged || parts.length == 8;
	}
	private InternetProtocol()
	{
		super();
	}
}
