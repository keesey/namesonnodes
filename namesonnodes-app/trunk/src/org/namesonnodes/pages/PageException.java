package org.namesonnodes.pages;

public class PageException extends Exception
{
	private static final long serialVersionUID = -6935212999920861219L;
	public PageException()
	{
		super();
	}
	public PageException(final String message)
	{
		super(message);
	}
	public PageException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public PageException(final Throwable cause)
	{
		super(cause);
	}
}
