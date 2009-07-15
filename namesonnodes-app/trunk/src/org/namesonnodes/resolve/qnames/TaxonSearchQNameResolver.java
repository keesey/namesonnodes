package org.namesonnodes.resolve.qnames;

import static org.hibernate.criterion.Restrictions.eq;
import static org.hibernate.criterion.Restrictions.like;
import java.net.MalformedURLException;
import java.net.URL;
import org.hibernate.Session;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class TaxonSearchQNameResolver implements QNameResolver
{
	private static URL createTaxURL(final String localName)
	{
		try
		{
			return new URL("http://www.taxonsearch.org/dev/taxon_edit.php?Action=View&tax_id=" + localName.substring(4));
		}
		catch (final MalformedURLException ex)
		{
			throw new RuntimeException(ex);
		}
	}
	private final Session session;
	public TaxonSearchQNameResolver(final Session session)
	{
		super();
		this.session = session;
	}
	public URL resolve(final QName qName)
	{
		if (qName.getUri().toString().startsWith("http://taxonsearch.org"))
		{
			if (qName.getUri().toString().equals("http://taxonsearch.org")
			        && qName.getLocalName().matches("^tax:\\d+$"))
				return createTaxURL(qName.getLocalName());
			final TaxonIdentifier name = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(
			        eq("QName", qName.toString())).uniqueResult();
			if (name == null)
				return null;
			final TaxonIdentifier taxIdentifier = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class).add(
			        eq("entity", name.getEntity())).add(like("QName", "http://taxonsearch.org::tax:%")).uniqueResult();
			if (taxIdentifier == null)
				return null;
			return createTaxURL(taxIdentifier.getLocalName());
		}
		return null;
	}
}
