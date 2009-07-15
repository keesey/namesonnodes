package org.namesonnodes.utils;

import java.io.ByteArrayOutputStream;

/**
 * Contains tools for handling string builders.
 * 
 * @author T. Michael Keesey
 * @see java.lang.StringBuilder
 */
public final class StringBuilderUtil
{
	/**
	 * Size ( in bytes) of the buffers used by the methods of this class.
	 */
	public static final int BUFFER_SIZE = 16384;
	/**
	 * Converts a string builder to an array of bytes.
	 * 
	 * @param builder
	 *            String builder.
	 * @return Array of characters.
	 */
	public static byte[] toByteArray(final StringBuilder builder)
	{
		final ByteArrayOutputStream out = new ByteArrayOutputStream();
		final int len = builder.length();
		for (int i = 0; i < len; i += BUFFER_SIZE)
		{
			int end = i + BUFFER_SIZE;
			if (end > len)
				end = len;
			final byte[] buffer = builder.substring(i, end).getBytes();
			out.write(buffer, 0, buffer.length);
		}
		return out.toByteArray();
	}
	/**
	 * Converts a string builder to an array of characters.
	 * 
	 * @param builder
	 *            String builder.
	 * @return Array of characters.
	 */
	public static char[] toCharArray(final StringBuilder builder)
	{
		final char[] chars = new char[builder.length()];
		final int len = builder.length();
		int i = 0;
		while (i < len)
		{
			int end = i + BUFFER_SIZE;
			if (end > len)
				end = len;
			final char[] buffer = builder.substring(i, end).toCharArray();
			System.arraycopy(buffer, 0, chars, i, buffer.length);
			i = end;
		}
		return chars;
	}
	/**
	 * (private)
	 */
	private StringBuilderUtil()
	{
	}
}
