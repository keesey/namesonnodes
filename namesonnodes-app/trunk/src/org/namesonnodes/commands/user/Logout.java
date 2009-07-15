package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserUtil.setSessionAuthority;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;

public final class Logout extends AbstractCommand<Object>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 470240980022897603L;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = {};
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = {};
		return v;
	}
	@Override
	protected Object doExecute(final Session session) throws CommandException
	{
		setSessionAuthority(null);
		return null;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
}
