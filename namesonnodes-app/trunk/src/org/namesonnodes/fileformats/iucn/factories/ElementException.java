package org.namesonnodes.fileformats.iucn.factories;

public class ElementException extends Exception
{
	private static final long serialVersionUID = 3285591842205282537L;
	public ElementException()
	{
		super();
	}
	public ElementException(final String message)
	{
		super(message);
	}
	public ElementException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public ElementException(final Throwable cause)
	{
		super(cause);
	}
}
