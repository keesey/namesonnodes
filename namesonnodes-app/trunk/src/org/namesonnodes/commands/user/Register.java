package org.namesonnodes.commands.user;

import static java.util.Calendar.YEAR;
import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.commands.user.UserStatus.PENDING_CONFIRMATION;
import static org.namesonnodes.commands.user.UserStatus.PREEXISTING;
import static org.namesonnodes.commands.user.UserStatus.UNDERAGE;
import static org.namesonnodes.mail.Mailer.SIGNATURE;
import static org.namesonnodes.mail.Mailer.SUBJECT_PREFIX;
import static org.namesonnodes.utils.Email.EMAIL_REGEX;
import static org.namesonnodes.utils.InternetProtocol.currentIPAddress;
import static org.namesonnodes.utils.URIUtil.escape;
import java.security.NoSuchAlgorithmException;
import java.util.Calendar;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.users.UserAccount;
import org.namesonnodes.mail.Mailer;

public final class Register extends AbstractCommand<Integer>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6163008428466482704L;
	private Calendar birthdate;
	private boolean commitRequired = false;
	private String email;
	private String familyName;
	private String fullName;
	public Register()
	{
		super();
	}
	public Register(final String email, final String fullName, final String familyName, final Calendar birthdate)
	{
		super();
		this.email = email;
		this.fullName = fullName;
		this.familyName = familyName;
		this.birthdate = birthdate;
	}
	public Register(final String email, final String fullName, final String familyName, final int year,
	        final int month, final int day)
	{
		super();
		this.email = email;
		this.fullName = fullName;
		this.familyName = familyName;
		final Calendar birthdate = Calendar.getInstance();
		birthdate.set(year, month, day);
		this.birthdate = birthdate;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "email", "familyName", "fullName", "birthdate" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] a = { email, familyName, fullName, birthdate };
		return a;
	}
	@Override
	protected Integer doExecute(final Session session) throws CommandException
	{
		if (!email.matches(EMAIL_REGEX))
			throw new CommandException("Invalid email address.");
		if (familyName.length() == 0)
			throw new CommandException("No family name.");
		if (fullName.length() == 0)
			throw new CommandException("No full name.");
		if (fullName.indexOf(familyName) < 0)
			throw new CommandException("Family name is not contained within full name.");
		final Calendar latestBirthdate = Calendar.getInstance();
		latestBirthdate.add(YEAR, -13);
		if (birthdate.after(latestBirthdate))
			return UNDERAGE;
		AuthorityIdentifier authorityIdentifier = (AuthorityIdentifier) session.createCriteria(
		        AuthorityIdentifier.class).add(eq("uri", "mailto:" + email)).uniqueResult();
		if (authorityIdentifier == null)
		{
			final Authority entity = new Authority();
			entity.getLabel().setAbbr(familyName);
			entity.getLabel().setName(fullName);
			authorityIdentifier = new AuthorityIdentifier();
			authorityIdentifier.setEntity(entity);
			authorityIdentifier.setUri("mailto:" + email);
		}
		else if (session.createCriteria(UserAccount.class).add(eq("authority", authorityIdentifier)).uniqueResult() != null)
			return PREEXISTING;
		final UserAccount account = new UserAccount(authorityIdentifier);
		String confirmationKey = "";
		try
		{
			confirmationKey = account.getConfirmationKey(currentIPAddress());
		}
		catch (final NoSuchAlgorithmException ex)
		{
			throw new CommandException(ex);
		}
		session.save(account);
		commitRequired = true;
		sendEmail(confirmationKey);
		return PENDING_CONFIRMATION;
	}
	public final Calendar getBirthdate()
	{
		return birthdate;
	}
	public final String getEmail()
	{
		return email;
	}
	public final String getFamilyName()
	{
		return familyName;
	}
	public final String getFullName()
	{
		return fullName;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	private void sendEmail(final String confirmationKey) throws CommandException
	{
		String message = fullName + ",";
		message += "\r\n\r\n";
		message += "Your NAMES ON NODES account has been created for this email address (" + email + ").";
		message += " To use your account, you must confirm that this message was received.";
		message += " If you still have the NAMES ON NODES registration form open, you may copy the following characters into the field labelled \"Key\".";
		message += "\r\n\r\n\t" + confirmationKey + "\r\n\r\n";
		message += "Alternatively, you may go to the following web address (be sure to include the entire address):";
		message += "\r\n\r\n\thttp://namesonnodes.org/?email=" + escape(email) + "&confirmation=" + confirmationKey
		        + "\r\n\r\n";
		message += "You will have to do this again if you log in from another location, or if your connection's address changes.";
		message += "\r\n\r\nIf you experience any problems, please contact Mike Keesey: keesey@gmail.com";
		message += "\r\n\r\nEnjoy!\r\n" + SIGNATURE;
		try
		{
			Mailer.send(email, SUBJECT_PREFIX + "Your Account", message);
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
	public final void setBirthdate(final Calendar birthdate)
	{
		this.birthdate = birthdate;
	}
	public final void setEmail(final String email)
	{
		this.email = email == null ? email : "";
	}
	public final void setFamilyName(final String familyName)
	{
		this.familyName = familyName == null ? familyName : "";
	}
	public final void setFullName(final String fullName)
	{
		this.fullName = fullName == null ? fullName : "";
	}
}
