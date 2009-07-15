package org.namesonnodes.summarizers;

import org.hibernate.Session;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class SummarizerFactory
{
	private final Session session;
	public SummarizerFactory(final Session session)
	{
		super();
		this.session = session;
	}
	@SuppressWarnings("unchecked")
	public <E extends Persistent> Summarizer<E> createSummarizer(final Class<E> entityClass)
	{
		if (entityClass == Authority.class)
			return (Summarizer<E>) new AuthoritySummarizer();
		if (entityClass == AuthorityIdentifier.class)
			return (Summarizer<E>) new AuthorityIdentifierSummarizer();
		if (entityClass == Dataset.class)
			return (Summarizer<E>) new DatasetSummarizer();
		if (entityClass == Taxon.class)
			return (Summarizer<E>) new TaxonSummarizer(session);
		if (entityClass == TaxonIdentifier.class)
			return (Summarizer<E>) new TaxonIdentifierSummarizer();
		return null;
	}
}
