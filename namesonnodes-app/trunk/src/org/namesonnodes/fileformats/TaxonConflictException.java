package org.namesonnodes.fileformats;

public final class TaxonConflictException extends Exception
{
	private static final long serialVersionUID = 8217045264027353308L;
	public TaxonConflictException()
	{
		super();
	}
	public TaxonConflictException(final String message)
	{
		super(message);
	}
	public TaxonConflictException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
	public TaxonConflictException(final Throwable cause)
	{
		super(cause);
	}
}
