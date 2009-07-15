package org.namesonnodes.commands.publication;

import static org.namesonnodes.utils.CollectionUtil.createStringList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.niso.sici.ChronologyDate;

public final class CreatePublication extends AbstractCommand<AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8461732339707322235L;
	private static String joinAuthors(final List<String> authors)
	{
		final int n = authors.size();
		if (n == 0)
			return "";
		String s = authors.get(0);
		if (n > 1)
		{
			if (n > 2)
				for (final String name : authors.subList(1, n - 1))
					s += ", " + name;
			s += " & " + authors.get(n - 1);
		}
		return s;
	}
	private List<String> authorFamilyNames;
	private List<String> authorFullNames;
	private boolean commitRequired = false;
	private ChronologyDate date;
	private String uri;
	public CreatePublication()
	{
		super();
	}
	public CreatePublication(final String authorFamilyNames, final String authorFullNames, final ChronologyDate date,
	        final String uri)
	{
		super();
		this.authorFamilyNames = createStringList(authorFamilyNames.split("\\s*[,;]\\s*"));
		this.authorFullNames = createStringList(authorFullNames.split("\\s*[,;]\\s*"));
		this.date = date;
		this.uri = uri;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "authorFamilyNames", "authorFullNames", "date", "uri" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { authorFamilyNames, authorFullNames, date, uri };
		return v;
	}
	@Override
	protected AuthorityIdentifier doExecute(final Session session) throws CommandException
	{
		boolean useEtAl = false;
		if (uri == null || uri.length() == 0)
			throw new CommandException("No URI provided.");
		if (authorFullNames == null || authorFullNames.isEmpty())
			throw new CommandException("No full names for authors provided.");
		if (authorFamilyNames == null || authorFamilyNames.isEmpty())
			throw new CommandException("No family names for authors provided.");
		if (authorFullNames.size() == 2)
		{
			if (authorFamilyNames.size() < 2)
				throw new CommandException("Missing an author's family name.");
			authorFamilyNames = authorFamilyNames.subList(0, 2);
		}
		else
		{
			authorFamilyNames = authorFamilyNames.subList(0, 1);
			useEtAl = authorFullNames.size() > 2;
		}
		if (date == null)
			throw new CommandException("No date.");
		if (date.getYear() == 0)
			throw new CommandException("No year.");
		final String name = joinAuthors(authorFullNames) + " " + String.valueOf(date.getYear());
		final String abbr = joinAuthors(authorFamilyNames) + (useEtAl ? " & al." : "") + " " + date.toLabelString();
		final Authority authority = new Authority();
		authority.getLabel().setAbbr(abbr);
		authority.getLabel().setName(name);
		// session.merge(authority);
		final AuthorityIdentifier publication = new AuthorityIdentifier(authority, uri);
		session.save(publication);
		commitRequired = true;
		return publication;
	}
	public final List<String> getAuthorFamilyNames()
	{
		return authorFamilyNames;
	}
	public final List<String> getAuthorFullNames()
	{
		return authorFullNames;
	}
	public final ChronologyDate getDate()
	{
		return date;
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
	public final void setAuthorFamilyNames(final List<String> authorFamilyNames)
	{
		this.authorFamilyNames = authorFamilyNames;
	}
	public final void setAuthorFullNames(final List<String> authorFullNames)
	{
		this.authorFullNames = authorFullNames;
	}
	public final void setDate(final ChronologyDate date)
	{
		this.date = date;
	}
	public final void setUri(final String uri)
	{
		this.uri = uri;
	}
}
