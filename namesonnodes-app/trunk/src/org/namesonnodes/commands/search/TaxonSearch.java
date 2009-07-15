package org.namesonnodes.commands.search;

import java.util.ArrayList;
import java.util.List;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Query;
import org.hibernate.Session;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.Search;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class TaxonSearch extends AbstractCommand<List<Taxon>>
{
	private static final long serialVersionUID = -149740157588523421L;
	private int maxResults = 16;
	private String text;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "text" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { text };
		return v;
	}
	private Query createLuceneQuery(final QueryParser parser, final boolean strict) throws CommandException
	{
		final String text = this.text.replaceAll("[^A-Za-z0-9À-ÖØ-öø-ǿ']+", " ");
		final String[] words = text.split("\\s+");
		String lucene = "";
		for (final String word : words)
			lucene += word + "^10 ";
		if (!strict)
			for (final String word : words)
				lucene += word + "~ ";
		lucene = lucene.trim();// substring(0, lucene.length() - 4);
		// System.out.println("[QUERY] " + lucene);
		try
		{
			return parser.parse(lucene);
		}
		catch (final ParseException ex)
		{
			throw new CommandException(ex);
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	protected List<Taxon> doExecute(final Session session) throws CommandException
	{
		if (text == null || text.length() < 2 || maxResults <= 0)
			return new ArrayList<Taxon>();
		final FullTextSession fullTextSession = Search.getFullTextSession(session);
		final List all = session.createCriteria(TaxonIdentifier.class).list();
		for (final Object identifier : all)
			fullTextSession.index(identifier);
		final QueryParser parser = new QueryParser("label.name", new StandardAnalyzer());
		final List<TaxonIdentifier> identifiers = new ArrayList<TaxonIdentifier>();
		runLuceneQuery(identifiers, fullTextSession, parser, true);
		if (identifiers.isEmpty())
			runLuceneQuery(identifiers, fullTextSession, parser, false);
		final List<Taxon> taxa = new ArrayList<Taxon>();
		for (final TaxonIdentifier identifier : identifiers)
			if (!taxa.contains(identifier.getEntity()))
			{
				taxa.add(identifier.getEntity());
				if (taxa.size() >= maxResults)
					break;
			}
		return taxa;
	}
	public final int getMaxResults()
	{
		return maxResults;
	}
	public final String getText()
	{
		return text;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	private void runLuceneQuery(final List<TaxonIdentifier> list, final FullTextSession fullTextSession,
	        final QueryParser parser, final boolean strict) throws CommandException
	{
		final Query query = createLuceneQuery(parser, strict);
		final org.hibernate.Query hQuery = fullTextSession.createFullTextQuery(query, TaxonIdentifier.class);
		hQuery.setMaxResults(maxResults * 4);
		for (final Object identifier : hQuery.list())
			list.add((TaxonIdentifier) identifier);
	}
	public final void setMaxResults(final int maxResults)
	{
		this.maxResults = maxResults;
	}
	public final void setText(final String text)
	{
		this.text = text;
	}
}
