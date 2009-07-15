package org.namesonnodes.niso;

public class NISOException extends Exception
{
	private static final long serialVersionUID = 4103222361728238919L;
	public NISOException()
	{
		super();
	}
	public NISOException(final String message)
	{
		super(message);
	}
	public NISOException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public NISOException(final Throwable cause)
	{
		super(cause);
	}
}
