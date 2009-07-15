package org.namesonnodes.utils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public final class URIUtil
{
	public static String ENCODING = "UTF-8";
	public static final String URI_PATTERN = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$";
	public static String escape(final String s)
	{
		if (s == null)
			throw new IllegalArgumentException("Cannot escape null string.");
		try
		{
			return URLEncoder.encode(s, ENCODING);
		}
		catch (final UnsupportedEncodingException ex)
		{
			throw new RuntimeException(ex);
		}
	}
	public static String[] escape(final String[] s)
	{
		final String[] escaped = new String[s.length];
		final int n = escaped.length;
		for (int i = 0; i < n; ++i)
			escaped[i] = escape(s[i]);
		return escaped;
	}
	public static boolean isQName(final String s)
	{
		if (s == null)
			return false;
		return s.matches("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?::.+$");
	}
	public static boolean isURI(final String s)
	{
		if (s == null)
			return false;
		return s.matches("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$");
	}
	public static String unescape(final String s)
	{
		try
		{
			return URLDecoder.decode(s, ENCODING);
		}
		catch (final UnsupportedEncodingException ex)
		{
			throw new RuntimeException(ex);
		}
	}
	private URIUtil()
	{
		super();
	}
}
