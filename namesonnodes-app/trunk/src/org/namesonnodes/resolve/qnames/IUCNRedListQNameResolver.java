package org.namesonnodes.resolve.qnames;

import static org.hibernate.criterion.Restrictions.eq;
import static org.hibernate.criterion.Restrictions.like;
import java.net.MalformedURLException;
import java.net.URL;
import org.hibernate.Session;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class IUCNRedListQNameResolver implements QNameResolver
{
	private static URL createSpeciesURL(final String localName)
	{
		try
		{
			return new URL("http://www.iucnredlist.org/details/" + localName.substring(8));
		}
		catch (final MalformedURLException ex)
		{
			throw new RuntimeException(ex);
		}
	}
	private final Session session;
	public IUCNRedListQNameResolver(final Session session)
	{
		super();
		this.session = session;
	}
	public URL resolve(final QName qName)
	{
		if (qName.getUri().toString().equals("http://iucnredlist.org"))
		{
			if (qName.getLocalName().matches("^species:\\d+$"))
				return createSpeciesURL(qName.getLocalName());
			if (qName.getLocalName().matches("^common_name:[^:]+:[^:]+$"))
			{
				final TaxonIdentifier commonName = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(
				        eq("QName", qName.toString())).uniqueResult();
				if (commonName == null)
					return null;
				final TaxonIdentifier speciesName = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class)
				        .add(eq("entity", commonName.getEntity())).add(
				                like("QName", "http://iucnredlist.org::species:%")).uniqueResult();
				if (speciesName == null)
					return null;
				return createSpeciesURL(speciesName.getLocalName());
			}
		}
		return null;
	}
}
