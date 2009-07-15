package org.namesonnodes.utils;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * Contains tools for handling arrays.
 * 
 * @author T. Michael Keesey
 */
public final class ArrayUtil
{
	/**
	 * Size ( in bytes) of the buffers used by the methods of this class.
	 */
	public static final int BUFFER_SIZE = 16384;
	/**
	 * Converts an array of bytes to an array of characters.
	 * 
	 * @param bytes
	 *            Array of bytes.
	 * @return Array of characters.
	 */
	public static char[] bytesToChars(final byte[] bytes)
	{
		char[] chars = new char[0];
		final int bytesLen = bytes.length;
		int bytePos = 0;
		while (bytePos < bytesLen)
		{
			int numBytes = bytesLen - bytePos;
			if (numBytes > BUFFER_SIZE)
				numBytes = BUFFER_SIZE;
			final char[] buffer = new String(bytes, bytePos, numBytes).toCharArray();
			final char[] temp = new char[chars.length + buffer.length];
			System.arraycopy(buffer, 0, temp, chars.length, buffer.length);
			chars = temp;
			bytePos += numBytes;
		}
		return chars;
	}
	/**
	 * Converts an array of characters to an array of bytes.
	 * 
	 * @param chars
	 *            Array of characters.
	 * @return Array of bytes.
	 * @throws IOException
	 *             If an I/O error occurs.
	 */
	public static byte[] charsToBytes(final char[] chars) throws IOException
	{
		final ByteArrayOutputStream out = new ByteArrayOutputStream();
		final int charsLen = chars.length;
		int charPos = 0;
		while (charPos < charsLen)
		{
			int numChars = charsLen - charPos;
			if (numChars > BUFFER_SIZE)
				numChars = BUFFER_SIZE;
			out.write(new String(chars, charPos, numChars).getBytes());
			charPos += numChars;
		}
		return out.toByteArray();
	}
	public static String join(final Object[] array, final String separator)
	{
		String s = "";
		boolean first = true;
		for (final Object o : array)
		{
			if (first)
				first = false;
			else
				s += separator;
			s += o.toString();
		}
		return s;
	}
	/**
	 * (private)
	 */
	private ArrayUtil()
	{
		super();
	}
}
