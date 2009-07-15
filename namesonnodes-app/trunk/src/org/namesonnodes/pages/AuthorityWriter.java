package org.namesonnodes.pages;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Collection;
import java.util.Comparator;
import java.util.SortedSet;
import java.util.TreeSet;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.identity.FindEquivalentAuthorities;
import org.namesonnodes.commands.identity.FindEquivalentEntities;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.resolve.uris.TotalURIResolver;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public final class AuthorityWriter extends AbstractPageWriter<Authority>
{
	private static class AuthorityIdentifierComparator implements Comparator<AuthorityIdentifier>
	{
		public int compare(final AuthorityIdentifier a, final AuthorityIdentifier b)
		{
			return a.getUri().compareTo(b.getUri());
		}
	}
	private final Session session;
	private final TitleBuilder<Authority> titleBuilder = new LabelledTitleBuilder<Authority>();
	public AuthorityWriter(final Session session)
	{
		super();
		this.session = session;
	}
	@Override
	protected void buildContentElement(final Document doc, final Element container, final Authority entity)
	        throws PageException
	{
		final FindEquivalentEntities<Authority, AuthorityIdentifier> find = new FindEquivalentAuthorities(
		        new WrapEntity<Authority>(entity));
		try
		{
			final SortedSet<AuthorityIdentifier> identifiers = new TreeSet<AuthorityIdentifier>(
			        new AuthorityIdentifierComparator());
			identifiers.addAll(find.execute(session));
			buildIdentifierList(doc, container, identifiers);
		}
		catch (final CommandException ex)
		{
			throw new PageException(ex);
		}
	}
	private void buildIdentifierList(final Document doc, final Element container,
	        final Collection<AuthorityIdentifier> identifiers) throws PageException
	{
		if (identifiers.isEmpty())
		{
			final Element pElement = doc.createElement("p");
			pElement.setTextContent("There are no URIs associated with this authority.");
			container.appendChild(pElement);
			return;
		}
		final Element ulElement = doc.createElement("ul");
		final Element lhElement = doc.createElement("lh");
		lhElement.setTextContent("Associated URI" + (identifiers.size() == 1 ? "" : "s") + ":");
		ulElement.appendChild(lhElement);
		for (final AuthorityIdentifier identifier : identifiers)
		{
			URI uri;
			try
			{
				uri = new URI(identifier.getUri());
			}
			catch (final URISyntaxException ex)
			{
				throw new PageException(ex);
			}
			final URL url = TotalURIResolver.INSTANCE.resolve(uri);
			final Element liElement = doc.createElement("li");
			liElement.setAttribute("class", "uri");
			if (url == null)
				liElement.setTextContent(uri.toString());
			else
			{
				final Element aElement = doc.createElement("a");
				aElement.setAttribute("href", url.toString());
				aElement.setTextContent(uri.toString());
				liElement.appendChild(aElement);
			}
			ulElement.appendChild(liElement);
		}
		container.appendChild(ulElement);
	}
	@Override
	protected void buildTitleElement(final Document doc, final Element container, final Authority entity)
	        throws PageException
	{
		titleBuilder.buildTitleElement(doc, container, entity);
	}
	@Override
	protected String getPageTitle(final Authority entity) throws PageException
	{
		return titleBuilder.getPageTitle(entity);
	}
}
