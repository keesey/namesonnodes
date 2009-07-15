package org.namesonnodes.commands.specimens;

import static org.hibernate.criterion.Restrictions.ilike;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.utils.URIUtil;

public final class CreateCatalogue extends AbstractCommand<AuthorityIdentifier>
{
	private static final long serialVersionUID = 8668161126835354537L;
	private String abbr;
	private boolean commitRequired = false;
	private String name;
	private String uri;
	private boolean allowExisting = true;
	public CreateCatalogue()
	{
		super();
	}
	public CreateCatalogue(final String name, final String abbr, final String uri)
	{
		super();
		this.name = name;
		this.abbr = abbr;
		this.uri = uri;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "abbr", "name", "uri" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { abbr, name, uri };
		return v;
	}
	@Override
	protected AuthorityIdentifier doExecute(final Session session) throws CommandException
	{
		if (name == null || name.length() == 0)
			throw new CommandException("No name provided for specimen catalogue");
		if (abbr != null && abbr.length() == 0)
			abbr = null;
		if (!URIUtil.isURI(uri))
			throw new CommandException("Invalid URI: " + uri);
		AuthorityIdentifier authorityIdentifier = (AuthorityIdentifier) session.createCriteria(
		        AuthorityIdentifier.class).add(ilike("uri", uri)).uniqueResult();
		if (authorityIdentifier != null)
			if (!allowExisting)
				throw new CommandException("There is already an authority with the same URI: <" + uri + ">.");
			else
				return authorityIdentifier;
		Authority entity = (Authority) session.createCriteria(Authority.class).add(ilike("label.name", name))
		        .uniqueResult();
		if (entity == null)
		{
			entity = new Authority();
			entity.getLabel().setAbbr(abbr);
			entity.getLabel().setName(name);
			// session.merge(entity);
			// commitRequired = true;
		}
		authorityIdentifier = new AuthorityIdentifier(entity, uri);
		session.save(authorityIdentifier);
		commitRequired = true;
		return authorityIdentifier;
	}
	public final String getAbbr()
	{
		return abbr;
	}
	public boolean getAllowExisting()
	{
		return allowExisting;
	}
	public final String getName()
	{
		return name;
	}
	public final String getUri()
	{
		return uri;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setAbbr(final String abbr)
	{
		this.abbr = abbr;
	}
	public void setAllowExisting(final boolean allowExisting)
	{
		this.allowExisting = allowExisting;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
	public final void setUri(final String uri)
	{
		this.uri = uri;
	}
}
