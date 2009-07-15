package org.namesonnodes.commands.authorization;

import static org.hibernate.criterion.Restrictions.eq;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Authorized;

public abstract class FindAuthorized<A extends Authorized> extends AbstractCommand<Set<A>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6553501425858538553L;
	private Command<AuthorityIdentifier> authorityCommand;
	private final Class<A> entityClass;
	public FindAuthorized(final Class<A> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	public FindAuthorized(final Class<A> entityClass, final Command<AuthorityIdentifier> authorityCommand)
	{
		super();
		this.entityClass = entityClass;
		this.authorityCommand = authorityCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "authority" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { authorityCommand };
		return v;
	}
	@SuppressWarnings("unchecked")
	@Override
	protected Set<A> doExecute(final Session session) throws CommandException
	{
		final AuthorityIdentifier authorityIdentifier = acquire(authorityCommand, session, "authority");
		final List list = session.createCriteria(entityClass).add(eq("authority", authorityIdentifier)).list();
		final Set<A> authorized = new HashSet<A>();
		for (final Object item : list)
			authorized.add((A) item);
		return authorized;
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return authorityCommand;
	}
	public boolean readOnly()
	{
		return authorityCommand != null && authorityCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return commandRequiresCommit(authorityCommand);
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		this.authorityCommand = authorityCommand;
	}
}
