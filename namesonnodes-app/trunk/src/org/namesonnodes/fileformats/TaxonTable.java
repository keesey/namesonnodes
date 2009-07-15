package org.namesonnodes.fileformats;

import static org.namesonnodes.utils.URIUtil.escape;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import org.hibernate.Session;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public class TaxonTable
{
	private final AuthorityIdentifier authority;
	private final Map<String, TaxonIdentifier> map = new HashMap<String, TaxonIdentifier>();
	private final Session session;
	public TaxonTable(final Session session, final AuthorityIdentifier authority)
	{
		super();
		this.authority = authority;
		this.session = session;
	}
	public void clear()
	{
		map.clear();
	}
	public boolean containsTaxon(final String label)
	{
		return map.containsKey(findTaxonLocalName(label));
	}
	private TaxonIdentifier create(final String localName, final String name)
	{
		final Taxon entity = new Taxon();
		final TaxonIdentifier taxonIdentifier = new TaxonIdentifier();
		taxonIdentifier.setAuthority(authority);
		taxonIdentifier.setEntity(entity);
		taxonIdentifier.getLabel().setName(name);
		taxonIdentifier.setLocalName(localName);
		map.put(localName, taxonIdentifier);
		// session.persist(taxonIdentifier);
		return taxonIdentifier;
	}
	protected String findStateLocalName(final String charLabel, final String stateLabel)
	{
		return escape(charLabel.replace('_', ' ')) + ":" + escape(stateLabel.replace('_', ' '));
	}
	protected String findTaxonLocalName(final String label)
	{
		return escape(label.replace('_', ' '));
	}
	public AuthorityIdentifier getAuthority()
	{
		return authority;
	}
	public Session getSession()
	{
		return session;
	}
	public TaxonIdentifier getState(final String charLabel, final String stateLabel)
	{
		final String localName = findStateLocalName(charLabel, stateLabel);
		if (map.containsKey(localName))
			return map.get(localName);
		return create(localName, charLabel.replace('_', ' ') + ": " + stateLabel.replace('_', ' '));
	}
	public TaxonIdentifier getTaxon(final String label)
	{
		if (label == null)
			throw new IllegalArgumentException("Null taxon label.");
		if (label.length() == 0)
			throw new IllegalArgumentException("Empty taxon label.");
		final String localName = findTaxonLocalName(label);
		if (map.containsKey(localName))
			return map.get(localName);
		return create(localName, label.replace('_', ' '));
	}
	public void put(final TaxonIdentifier taxonIdentifier) throws TaxonConflictException
	{
		if (map.containsKey(taxonIdentifier.getLocalName()))
			throw new TaxonConflictException("Conflicting taxon identifierss: " + taxonIdentifier.getLocalName());
		// session.persist(taxonIdentifier);
		map.put(taxonIdentifier.getLocalName(), taxonIdentifier);
	}
	public Collection<TaxonIdentifier> values()
	{
		return map.values();
	}
}
