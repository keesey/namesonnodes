package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserUtil.sessionUserAccount;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.identity.FindEquivalentAuthorities;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.users.UserAccount;

public final class LoadUserIdentifiers extends AbstractCommand<Set<AuthorityIdentifier>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5642144016704672856L;
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
	protected Set<AuthorityIdentifier> doExecute(final Session session) throws CommandException
	{
		final UserAccount account = sessionUserAccount(session);
		if (account == null)
			return new HashSet<AuthorityIdentifier>();
		final FindEquivalentAuthorities findEquivalentAuthorities = new FindEquivalentAuthorities();
		findEquivalentAuthorities.setEntityCommand(new WrapEntity<Authority>(account.getAuthority().getEntity()));
		return findEquivalentAuthorities.execute(session);
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
