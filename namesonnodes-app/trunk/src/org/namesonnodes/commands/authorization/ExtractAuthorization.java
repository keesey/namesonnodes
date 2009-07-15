package org.namesonnodes.commands.authorization;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Authorized;

public final class ExtractAuthorization extends AbstractCommand<AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 368399569001354113L;
	private Command<? extends Authorized> authorizedCommand;
	public ExtractAuthorization()
	{
		super();
	}
	public ExtractAuthorization(final Command<? extends Authorized> authorizedCommand)
	{
		super();
		this.authorizedCommand = authorizedCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "authorized" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { authorizedCommand };
		return v;
	}
	@Override
	protected AuthorityIdentifier doExecute(final Session session) throws CommandException
	{
		return acquire(authorizedCommand, session, "authorized entity").getAuthority();
	}
	public final Command<? extends Authorized> getAuthorizedCommand()
	{
		return authorizedCommand;
	}
	public boolean readOnly()
	{
		return authorizedCommand == null || authorizedCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(authorizedCommand);
	}
	public final void setAuthorizedCommand(final Command<? extends Authorized> authorizedCommand)
	{
		this.authorizedCommand = authorizedCommand;
	}
}
