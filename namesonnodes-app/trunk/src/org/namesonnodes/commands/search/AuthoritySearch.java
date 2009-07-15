package org.namesonnodes.commands.search;

import java.util.ArrayList;
import java.util.List;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Query;
import org.hibernate.Session;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.Search;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;

public final class AuthoritySearch extends AbstractCommand<List<Authority>>
{
	private static final long serialVersionUID = 3857879285000162366L;
	private int maxResults = 16;
	private String text;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "text", "maxResults" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { text, maxResults };
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
	@Override
	protected List<Authority> doExecute(final Session session) throws CommandException
	{
		final List<Authority> authorities = new ArrayList<Authority>();
		if (text == null || text.length() <= 1 || maxResults <= 0)
			return authorities;
		final FullTextSession fullTextSession = Search.getFullTextSession(session);
		try
		{
			final List<?> all = session.createCriteria(Authority.class).list();
			for (final Object authority : all)
				fullTextSession.index(authority);
			final String[] fields = { "label.name", "label.abbr" };
			final QueryParser parser = new MultiFieldQueryParser(fields, new StandardAnalyzer());
			runLuceneQuery(authorities, fullTextSession, parser, true);
			if (authorities.isEmpty())
				runLuceneQuery(authorities, fullTextSession, parser, false);
		}
		catch (final CommandException ex)
		{
			throw ex;
		}
		catch (final RuntimeException ex)
		{
			throw ex;
		}
		finally
		{
			fullTextSession.close();
		}
		return authorities;
	}
	public int getMaxResults()
	{
		return maxResults;
	}
	public String getText()
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
	private void runLuceneQuery(final List<Authority> list, final FullTextSession fullTextSession,
	        final QueryParser parser, final boolean strict) throws CommandException
	{
		final Query query = createLuceneQuery(parser, strict);
		final org.hibernate.Query hQuery = fullTextSession.createFullTextQuery(query, Authority.class);
		for (final Object authority : hQuery.list())
			list.add((Authority) authority);
	}
	public void setMaxResults(final int maxResults)
	{
		this.maxResults = maxResults;
	}
	public void setText(final String text)
	{
		this.text = text;
	}
}
