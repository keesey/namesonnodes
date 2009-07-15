package org.namesonnodes.html;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.identity.FindEquivalentAuthorities;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.resolve.uris.TotalURIResolver;

public final class AuthorityAssistant implements EntityHTMLAssistant<Authority>
{
	private final Session session;
	public AuthorityAssistant(final Session session)
	{
		super();
		this.session = session;
	}
	public String getAbstract(final Authority entity)
	{
		String abs = "<b>" + entity.getLabel().toHTMLText() + "</b> is an <b>authority</b>.";
		abs += " Each authority corresponds to one or more <a href=\"http://tools.ietf.org/html/rfc3986\">Universal Resource Identifier</a>s (URIs).";
		abs += " Authorities may authorize (or qualify) both taxon identifiers and datasets.";
		return abs;
	}
	public String getClassName()
	{
		return "Authority";
	}
	public String getDescription(final Authority entity)
	{
		return entity.getLabel().getName() + " is an authority in the Names on Nodes database.";
	}
	public List<Link> getEntityLinks(final Authority entity)
	{
		final List<Link> links = new ArrayList<Link>();
		Set<AuthorityIdentifier> identifiers;
		try
		{
			identifiers = new FindEquivalentAuthorities(new WrapEntity<Authority>(entity)).execute(session);
		}
		catch (final CommandException e)
		{
			throw new RuntimeException(e);
		}
		for (final AuthorityIdentifier identifier : identifiers)
			links
			        .add(new Link("/namesonnodes/entity/authorityidentifier:" + identifier.getId(), "<code>"
			                + identifier.getUri() + "</code>",
			                " is a URI that identifies this authority. Follow the link for more about entities authorized by this authority."));
		return links;
	}
	public List<Link> getExternalLinks(final Authority entity)
	{
		final List<Link> links = new ArrayList<Link>();
		Set<AuthorityIdentifier> identifiers;
		try
		{
			identifiers = new FindEquivalentAuthorities(new WrapEntity<Authority>(entity)).execute(session);
		}
		catch (final CommandException e)
		{
			throw new RuntimeException(e);
		}
		for (final AuthorityIdentifier identifier : identifiers)
		{
			URL url;
			try
			{
				url = TotalURIResolver.INSTANCE.resolve(new URI(identifier.getUri()));
			}
			catch (final URISyntaxException e)
			{
				url = null;
			}
			final Link link = new Link();
			link.url = url == null ? identifier.getUri() : url.toString();
			link.linkText = "<code>" + identifier.getUri() + "</code>";
			links.add(link);
		}
		return links;
	}
	public String getExtraContent(final Authority entity)
	{
		return "";
	}
	public String getHeader(final Authority entity)
	{
		String header = "<h1>" + entity.getLabel().toHTMLText() + "</h1>";
		if (entity.getLabel().getAbbr() != null)
			header += "<h2>(" + entity.getLabel().toShortHTMLText() + ")</h2>";
		return header;
	}
	public Set<String> getKeywords(final Authority entity)
	{
		final Set<String> keywords = new HashSet<String>();
		keywords.add("authority");
		keywords.add("authorities");
		keywords.add("authorize");
		keywords.add("authorization");
		keywords.add(entity.getLabel().getName());
		for (final String keyword : entity.getLabel().getName().split("[- \\(\\)]+"))
			keywords.add(keyword.toLowerCase());
		if (entity.getLabel().getAbbr() != null)
		{
			keywords.add(entity.getLabel().getAbbr());
			for (final String keyword : entity.getLabel().getAbbr().split("[- \\(\\)]+"))
				keywords.add(keyword.toLowerCase());
		}
		return keywords;
	}
	public String getName(final Authority entity)
	{
		return entity.getLabel().toHTMLText();
	}
	public String getTableName()
	{
		return "authority";
	}
}
