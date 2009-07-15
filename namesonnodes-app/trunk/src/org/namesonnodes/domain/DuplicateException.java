package org.namesonnodes.domain;

public class DuplicateException extends Exception
{
	private static final long serialVersionUID = -2036287035093686340L;
	private final int duplicateID;
	public DuplicateException(final int duplicateID)
	{
		super("Duplicate entity: #" + duplicateID);
		this.duplicateID = duplicateID;
	}
	public int getDuplicateID()
	{
		return duplicateID;
	}
}
