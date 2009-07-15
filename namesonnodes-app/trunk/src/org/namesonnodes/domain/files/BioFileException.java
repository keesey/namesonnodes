package org.namesonnodes.domain.files;

public class BioFileException extends Exception
{
	private static final long serialVersionUID = 1L;
	public BioFileException(final String message)
	{
		super(message);
	}
	public BioFileException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public BioFileException(final Throwable cause)
	{
		super(cause);
	}
}
