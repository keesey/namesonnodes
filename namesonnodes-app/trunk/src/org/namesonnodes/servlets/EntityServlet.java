package org.namesonnodes.servlets;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.load.Load;
import org.namesonnodes.commands.load.LoadAuthority;
import org.namesonnodes.commands.load.LoadAuthorityIdentifier;
import org.namesonnodes.commands.load.LoadTaxonIdentifier;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.html.AuthorityAssistant;
import org.namesonnodes.html.AuthorityIdentifierAssistant;
import org.namesonnodes.html.EntityHTMLWriter;
import org.namesonnodes.html.TaxonIdentifierAssistant;
import org.namesonnodes.persist.HibernateBundle;

public final class EntityServlet extends HttpServlet
{
	private static final long serialVersionUID = -6355361276690972558L;
	private static String writeAuthorityContent(final int id, final Session session) throws CommandException
	{
		final Load<Authority> command = new LoadAuthority();
		command.setId(id);
		final Authority entity = command.execute(session);
		if (entity == null)
			throw new IllegalArgumentException("No such authority in Names on Nodes database.");
		return EntityHTMLWriter.INSTANCE.write(entity, new AuthorityAssistant(session));
	}
	private static String writeAuthorityIdentifierContent(final int id, final Session session) throws CommandException
	{
		final Load<AuthorityIdentifier> command = new LoadAuthorityIdentifier();
		command.setId(id);
		final AuthorityIdentifier entity = command.execute(session);
		if (entity == null)
			throw new IllegalArgumentException("No such authority identifier in Names on Nodes database.");
		return EntityHTMLWriter.INSTANCE.write(entity, new AuthorityIdentifierAssistant(session));
	}
	private static String writeContent(final String tableName, final int id) throws CommandException
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			String content = null;
			if (tableName.equals("authority"))
				content = writeAuthorityContent(id, hb.getSession());
			else if (tableName.equals("authorityidentifier"))
				content = writeAuthorityIdentifierContent(id, hb.getSession());
			else if (tableName.equals("taxonidentifier"))
				content = writeTaxonIdentifierContent(id, hb.getSession());
			if (content != null)
				return content;
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
			hb.cancel();
		}
		throw new IllegalArgumentException("Invalid Names on Nodes entity class (" + tableName + ").");
	}
	private static String writeTaxonIdentifierContent(final int id, final Session session) throws CommandException
	{
		final Load<TaxonIdentifier> command = new LoadTaxonIdentifier();
		command.setId(id);
		final TaxonIdentifier entity = command.execute(session);
		if (entity == null)
			throw new IllegalArgumentException("No such taxon identifier in Names on Nodes database.");
		return EntityHTMLWriter.INSTANCE.write(entity, new TaxonIdentifierAssistant(session));
	}
	@Override
	protected void doGet(final HttpServletRequest req, final HttpServletResponse resp) throws ServletException,
	        IOException
	{
		try
		{
			final URI uri = new URI(req.getRequestURI());
			final String localName = uri.getRawPath().replaceFirst("^\\/namesonnodes\\/entity\\/", "").toLowerCase();
			if (!localName.matches("^[a-z]+:\\d+"))
				resp.sendError(404, "Invalid Names on Nodes entity specification.");
			else
			{
				final String[] parts = localName.split(":");
				final String tableName = parts[0];
				final int id = new Integer(parts[1]);
				if (id <= 0)
					resp.sendError(404, "Invalid Names on Nodes ID.");
				else
				{
					resp.setContentType("text/html");
					String content;
					try
					{
						content = writeContent(tableName, id);
					}
					catch (final IllegalArgumentException e)
					{
						resp.sendError(404, e.getMessage());
						return;
					}
					catch (final CommandException e)
					{
						throw new ServletException(e);
					}
					resp.getWriter().write(content);
					resp.getWriter().close();
				}
			}
		}
		catch (final URISyntaxException ex)
		{
			throw new ServletException(ex);
		}
	}
}
