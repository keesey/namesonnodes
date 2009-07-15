package org.namesonnodes.iso;

public class ISOException extends Exception
{
	private static final long serialVersionUID = -3723520526272429195L;
	public ISOException()
	{
		super();
	}
	public ISOException(final String message)
	{
		super(message);
	}
	public ISOException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public ISOException(final Throwable cause)
	{
		super(cause);
	}
}
