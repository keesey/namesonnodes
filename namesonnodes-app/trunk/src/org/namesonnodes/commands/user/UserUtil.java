package org.namesonnodes.commands.user;

import static flex.messaging.FlexContext.getFlexSession;
import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.utils.Email.EMAIL_REGEX;
import static org.namesonnodes.utils.URIUtil.URI_PATTERN;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.users.UserAccount;

final class UserUtil
{
	public static final String SESSION_AUTHORITY_URI_KEY = "UserAccount.current.authority.uri";
	public static UserAccount loadUserAccountFromEmail(final String email, final Session session)
	        throws CommandException
	{
		if (!email.matches(EMAIL_REGEX))
			throw new CommandException("Invalid email address.");
		return loadUserAccountFromURI("mailto:" + email, session);
	}
	private static UserAccount loadUserAccountFromURI(final String uri, final Session session) throws CommandException
	{
		if (!uri.matches(URI_PATTERN))
			throw new CommandException("Invalid URI.");
		final AuthorityIdentifier authority = new ResolveURI(uri).execute(session);
		if (authority == null)
			return null;
		return (UserAccount) session.createCriteria(UserAccount.class).add(eq("authority", authority)).uniqueResult();
	}
	public static UserAccount sessionUserAccount(final Session session) throws CommandException
	{
		if (getFlexSession() == null)
			throw new CommandException("Session unavailable.");
		final Object uri = getFlexSession().getAttribute(SESSION_AUTHORITY_URI_KEY);
		if (uri == null)
			return null;
		return loadUserAccountFromURI(uri.toString(), session);
	}
	public static void setSessionAuthority(final AuthorityIdentifier authority) throws CommandException
	{
		if (getFlexSession() == null)
			throw new CommandException("Session unavailable.");
		getFlexSession().setAttribute(SESSION_AUTHORITY_URI_KEY, authority == null ? null : authority.getUri());
	}
	private UserUtil()
	{
		super();
	}
}
