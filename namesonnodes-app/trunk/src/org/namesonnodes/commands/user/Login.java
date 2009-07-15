package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserStatus.LOGGED_IN;
import static org.namesonnodes.commands.user.UserStatus.PENDING_CONFIRMATION;
import static org.namesonnodes.commands.user.UserStatus.REGISTRATION_REQUIRED;
import static org.namesonnodes.commands.user.UserUtil.loadUserAccountFromEmail;
import static org.namesonnodes.commands.user.UserUtil.setSessionAuthority;
import static org.namesonnodes.mail.Mailer.SIGNATURE;
import static org.namesonnodes.mail.Mailer.SUBJECT_PREFIX;
import static org.namesonnodes.utils.InternetProtocol.currentIPAddress;
import static org.namesonnodes.utils.SHA1.HASH_PATTERN;
import static org.namesonnodes.utils.URIUtil.escape;
import java.security.NoSuchAlgorithmException;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.users.UserAccount;
import org.namesonnodes.mail.Mailer;

public final class Login extends AbstractCommand<Integer>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 989725439135989122L;
	private String email = "";
	private String locationKey = "";
	private boolean commitRequired;
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "email", "locationKey" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { email, locationKey };
		return v;
	}
	@Override
	protected Integer doExecute(final Session session) throws CommandException
	{
		if (locationKey != null && !locationKey.matches(HASH_PATTERN))
			throw new CommandException("Invalid login attempt.");
		final UserAccount account = loadUserAccountFromEmail(email, session);
		if (account == null)
			return REGISTRATION_REQUIRED;
		final String ipAddress = currentIPAddress();
		if (locationKey == null || !locationKey.equals(account.getLocationKeys().get(ipAddress)))
		{
			final String confirmationKey;
			try
			{
				confirmationKey = account.getConfirmationKey(ipAddress);
			}
			catch (final NoSuchAlgorithmException ex)
			{
				throw new CommandException(ex);
			}
			session.merge(account);
			commitRequired = true;
			sendEmail(account.getAuthority().getEntity().getLabel().getName(), confirmationKey);
			return PENDING_CONFIRMATION;
		}
		setSessionAuthority(account.getAuthority());
		return LOGGED_IN;
	}
	public final String getEmail()
	{
		return email;
	}
	public final String getLocationKey()
	{
		return locationKey;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	private void sendEmail(final String fullName, final String confirmationKey) throws CommandException
	{
		String message = fullName + ",\r\n\r\n";
		message += "You have attempted to log in to NAMES ON NODES from a new location (address: " + currentIPAddress()
		        + ").";
		message += " To use your account from this location, you must confirm that this message was received.";
		message += " If you still have the NAMES ON NODES confirmation window open, you may copy the following characters into the field labelled \"Key\".";
		message += "\r\n\r\n\t" + confirmationKey + "\r\n\r\n";
		message += "Alternatively, you may go to the following web address (be sure to include the entire address):";
		message += "\r\n\r\n\thttp://namesonnodes.org/?email=" + escape(email) + "&confirmation=" + confirmationKey
		        + "\r\n\r\n";
		message += "\r\n\r\nIf you experience any problems, please contact Mike Keesey: keesey@gmail.com";
		message += "\r\n\r\nEnjoy!" + SIGNATURE;
		try
		{
			Mailer.send(email, SUBJECT_PREFIX + "Login From New Location [" + currentIPAddress() + "]", message);
		}
		catch (final AddressException ex)
		{
			throw new CommandException(ex);
		}
		catch (final MessagingException ex)
		{
			throw new CommandException(ex);
		}
	}
	public final void setEmail(final String email)
	{
		this.email = email == null ? "" : email;
	}
	public final void setLocationKey(final String locationKey)
	{
		this.locationKey = locationKey == null ? "" : locationKey;
	}
}
