package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserUtil.loadUserAccountFromEmail;
import static org.namesonnodes.utils.InternetProtocol.currentIPAddress;
import static org.namesonnodes.utils.SHA1.HASH_PATTERN;
import java.security.NoSuchAlgorithmException;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.users.UserAccount;

public final class Confirm extends AbstractCommand<String>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2842063906433798556L;
	private boolean commitRequired;
	private String confirmationKey = "";
	private String email = "";
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "email", "confirmationKey" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { email, confirmationKey };
		return v;
	}
	@Override
	protected String doExecute(final Session session) throws CommandException
	{
		if (confirmationKey == null || !confirmationKey.matches(HASH_PATTERN))
			throw new CommandException("Invalid confirmation attempt.");
		final UserAccount account = loadUserAccountFromEmail(email, session);
		if (account == null)
			throw new CommandException("No such account.");
		final String ipAddress = currentIPAddress();
		if (confirmationKey.equals(account.getConfirmationKeys().get(ipAddress)))
			try
			{
				final String locationKey = account.getLocationKey(ipAddress);
				commitRequired = true;
				return locationKey;
			}
			catch (final NoSuchAlgorithmException ex)
			{
				throw new CommandException(ex);
			}
		throw new CommandException("Invalid confirmation.");
	}
	public final String getConfirmationKey()
	{
		return confirmationKey;
	}
	public final String getEmail()
	{
		return email;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setConfirmationKey(final String confirmationKey)
	{
		this.confirmationKey = confirmationKey;
	}
	public final void setEmail(final String email)
	{
		this.email = email;
	}
}
