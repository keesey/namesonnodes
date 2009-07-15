package org.namesonnodes.fileformats.iucn.translators;

public class TranslationException extends Exception
{
	private static final long serialVersionUID = 6382586804487271727L;
	public TranslationException()
	{
		super();
	}
	public TranslationException(final String message)
	{
		super(message);
	}
	public TranslationException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public TranslationException(final Throwable cause)
	{
		super(cause);
	}
}
