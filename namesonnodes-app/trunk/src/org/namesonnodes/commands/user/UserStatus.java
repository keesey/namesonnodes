package org.namesonnodes.commands.user;

public final class UserStatus
{
	public static final int LOGGED_IN = 1;
	public static final int PENDING_CONFIRMATION = 2;
	public static final int PREEXISTING = 4;
	public static final int REGISTRATION_REQUIRED = 3;
	public static final int UNDERAGE = 5;
	private UserStatus()
	{
		super();
	}
}
