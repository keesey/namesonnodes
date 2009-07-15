package org.namesonnodes.commands;

public class CommandException extends Exception
{
	private static final long serialVersionUID = 6654114802350941773L;
	public CommandException()
	{
		super();
	}
	public CommandException(final String message)
	{
		super(message);
	}
	public CommandException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public CommandException(final Throwable cause)
	{
		super(cause);
	}
}
