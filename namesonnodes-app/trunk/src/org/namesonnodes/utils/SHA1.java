package org.namesonnodes.utils;

import static java.lang.Math.random;
import static java.lang.System.currentTimeMillis;
import static org.namesonnodes.utils.ArrayUtil.charsToBytes;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Contains methods for SHA-1 encryption.
 * 
 * @author T. Michael Keesey
 * @see http://www.w3.org/PICS/DSig/SHA1_1_0.html
 */
public final class SHA1
{
	public static final String HASH_PATTERN = "^[a-f0-9]{40}$";
	/**
	 * Converts a byte array to a hexadecimal string.
	 * 
	 * @param bytes
	 *            Byte array.
	 * @return Hexadecimal string.
	 */
	private static String convertToHex(final byte[] bytes)
	{
		final StringBuffer buf = new StringBuffer();
		for (final byte element : bytes)
		{
			int halfbyte = element >>> 4 & 0x0F;
			int two_halfs = 0;
			do
			{
				if (0 <= halfbyte && halfbyte <= 9)
					buf.append((char) ('0' + halfbyte));
				else
					buf.append((char) ('a' + halfbyte - 10));
				halfbyte = element & 0x0F;
			} while (two_halfs++ < 1);
		}
		return buf.toString();
	}
	public static String createKey() throws NoSuchAlgorithmException
	{
		return encrypt(Long.toHexString(currentTimeMillis()) + ":" + Double.toHexString(random()));
	}
	/**
	 * Encrypts an array of bytes.
	 * 
	 * @param bytes
	 *            Array of bytes to encrypt.
	 * @return Encrypted string.
	 * @throws NoSuchAlgorithmException
	 *             If the SHA-1 algorithm is not available in the caller's
	 *             environment.
	 */
	public static String encrypt(final byte[] bytes) throws NoSuchAlgorithmException
	{
		final MessageDigest md = MessageDigest.getInstance("SHA-1");
		md.update(bytes);
		return convertToHex(md.digest());
	}
	/**
	 * Encrypts an array of characters.
	 * 
	 * @param bytes
	 *            Array of characters to encrypt.
	 * @return Encrypted string.
	 * @throws NoSuchAlgorithmException
	 *             If the SHA-1 algorithm is not available in the caller's
	 *             environment.
	 */
	public static String encrypt(final char[] chars) throws IOException, NoSuchAlgorithmException
	{
		return encrypt(charsToBytes(chars));
	}
	/**
	 * Encrypts a piece of text.
	 * 
	 * @param text
	 *            String to encrypt.
	 * @return Encrypted string.
	 * @throws NoSuchAlgorithmException
	 *             If the SHA-1 algorithm is not available in the caller's
	 *             environment.
	 */
	public static String encrypt(final String text) throws NoSuchAlgorithmException
	{
		if (text == null)
			return null;
		final MessageDigest md = MessageDigest.getInstance("SHA-1");
		md.update(text.getBytes());
		return convertToHex(md.digest());
	}
	/**
	 * (private)
	 */
	private SHA1()
	{
	}
}
