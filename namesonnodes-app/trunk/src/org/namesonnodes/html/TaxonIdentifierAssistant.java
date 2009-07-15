package org.namesonnodes.html;

import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.resolve.qnames.QName;
import org.namesonnodes.resolve.qnames.TotalQNameResolver;

public final class TaxonIdentifierAssistant implements EntityHTMLAssistant<TaxonIdentifier>
{
	private final Session session;
	public TaxonIdentifierAssistant(final Session session)
	{
		super();
		this.session = session;
	}
	public String getAbstract(final TaxonIdentifier entity)
	{
		String abs = "<b>" + entity.getLabel().toHTMLText() + "</b> is a <b>taxon identifier</b>.";
		abs += " It is equivalent to the qualified name <code>" + entity.getQName() + "</code>.";
		return abs;
	}
	public String getClassName()
	{
		return "Taxon Identifier";
	}
	public String getDescription(final TaxonIdentifier entity)
	{
		return entity.getLabel().getName() + " is an authority identifier in the Names on Nodes database.";
	}
	/*
	 * private String getTaxonName(final Taxon taxon) { Set<TaxonIdentifier>
	 * identifiers; try { identifiers = new FindEquivalentTaxa(new
	 * WrapEntity<Taxon>(taxon)).execute(session); } catch (CommandException e)
	 * { throw new RuntimeException(e); } if (identifiers.isEmpty()) return
	 * "innom."; final SortedSet<String> names = new TreeSet<String>(); for
	 * (final TaxonIdentifier identifier : identifiers)
	 * names.add(identifier.getLabel().toHTMLText()); return
	 * CollectionUtil.join(names, "/"); }
	 */
	public List<Link> getEntityLinks(final TaxonIdentifier entity)
	{
		final List<Link> links = new ArrayList<Link>();
		links.add(new Link("/namesonnodes/entity/taxon:" + entity.getEntity().getId(), "Taxon #"
		        + entity.getEntity().getId(), " is the taxon identified by this entity."));
		links.add(new Link("/namesonnodes/entity/authorityidentifier:" + entity.getAuthority().getId(), "<code>"
		        + entity.getAuthority().getUri() + "</code>", " identifies this entity's authority, "
		        + entity.getAuthority().getEntity().getLabel().toHTMLText() + "."));
		// :TODO: relations
		return links;
	}
	public List<Link> getExternalLinks(final TaxonIdentifier entity)
	{
		URL url;
		try
		{
			url = new TotalQNameResolver(session).resolve(new QName(entity.getQName()));
		}
		catch (final URISyntaxException e)
		{
			url = null;
		}
		final Link link = new Link();
		link.url = url == null ? entity.getAuthority().getUri() : url.toString();
		link.linkText = "<code>" + entity.getQName() + "</code>";
		final List<Link> links = new ArrayList<Link>();
		links.add(link);
		return links;
	}
	public String getExtraContent(final TaxonIdentifier entity)
	{
		return "";
	}
	public String getHeader(final TaxonIdentifier entity)
	{
		return "<h1>" + entity.getLabel().toHTMLText() + "</h1><h2><code>" + entity.getQName() + "</code></h2>";
	}
	public Set<String> getKeywords(final TaxonIdentifier entity)
	{
		final Set<String> keywords = new HashSet<String>();
		keywords.add("taxa");
		keywords.add("taxon");
		keywords.add("identifier");
		keywords.add("identification");
		keywords.add("identify");
		keywords.add("identity");
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
	public String getName(final TaxonIdentifier entity)
	{
		return entity.getLabel().getName();
	}
	public String getTableName()
	{
		return "taxonidentifier";
	}
}
