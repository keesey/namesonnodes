package org.namesonnodes.commands.resolve;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class ResolveURIList extends AbstractCommand<List<AuthorityIdentifier>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6953374202162614146L;
	private final List<String> uris = new ArrayList<String>();
	public ResolveURIList()
	{
		super();
	}
	public ResolveURIList(final List<String> uris)
	{
		super();
		setURIs(uris);
	}
	public ResolveURIList(final String uris)
	{
		this(uris, "\n");
	}
	public ResolveURIList(final String uris, final String separator)
	{
		super();
		if (uris != null && uris.length() > 0)
			for (final String uri : uris.split(separator))
				this.uris.add(uri);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "uris" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { uris };
		return v;
	}
	@Override
	protected List<AuthorityIdentifier> doExecute(final Session session) throws CommandException
	{
		final List<AuthorityIdentifier> list = new ArrayList<AuthorityIdentifier>();
		for (final String uri : uris)
			list.add(new ResolveURI(uri).execute(session));
		return list;
	}
	public final List<String> getURIs()
	{
		return uris;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setURIs(final List<String> names)
	{
		uris.clear();
		if (names != null)
			uris.addAll(names);
	}
}
