package org.namesonnodes.commands.resolve;

import static org.hibernate.criterion.Restrictions.ilike;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class ResolveURI extends AbstractCommand<AuthorityIdentifier>
{
	private static final long serialVersionUID = -6265130303884614356L;
	private String uri;
	public ResolveURI()
	{
		super();
	}
	public ResolveURI(final String uri)
	{
		super();
		this.uri = uri;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "uri" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { uri };
		return v;
	}
	@Override
	protected AuthorityIdentifier doExecute(final Session session) throws CommandException
	{
		if (uri == null || uri == "")
			throw new CommandException("No URI specified.");
		return (AuthorityIdentifier) session.createCriteria(AuthorityIdentifier.class).add(ilike("uri", uri))
		        .uniqueResult();
	}
	public final String getUri()
	{
		return uri;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setUri(final String uri)
	{
		this.uri = uri;
	}
}
