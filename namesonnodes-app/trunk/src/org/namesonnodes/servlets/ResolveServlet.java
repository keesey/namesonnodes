package org.namesonnodes.servlets;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.namesonnodes.persist.HibernateBundle;
import org.namesonnodes.resolve.qnames.QName;
import org.namesonnodes.resolve.qnames.QNameResolver;
import org.namesonnodes.resolve.qnames.TotalQNameResolver;
import org.namesonnodes.resolve.uris.TotalURIResolver;

public final class ResolveServlet extends HttpServlet
{
	private static final long serialVersionUID = 5947982877178114180L;
	protected static void redirectQName(final String qName, final HttpServletResponse resp) throws IOException,
	        ServletException
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			final QNameResolver resolver = new TotalQNameResolver(hb.getSession());
			final URL url = resolver.resolve(new QName(qName));
			if (url == null)
				throw new ServletException("Cannot resolve qualified name: <" + qName + ">.");
			final String encodedURL = resp.encodeRedirectURL(url.toExternalForm());
			resp.sendRedirect(encodedURL);
		}
		catch (final IOException ex)
		{
			throw ex;
		}
		catch (final RuntimeException ex)
		{
			throw ex;
		}
		catch (final URISyntaxException ex)
		{
			throw new ServletException(ex);
		}
		finally
		{
			hb.cancel();
		}
	}
	protected static void redirectURI(final String uri, final HttpServletResponse resp) throws IOException,
	        ServletException
	{
		try
		{
			final URL url = TotalURIResolver.INSTANCE.resolve(new URI(uri));
			if (url == null)
				throw new ServletException("Cannot resolve URI: <" + uri + ">.");
			final String encodedURL = resp.encodeRedirectURL(url.toExternalForm());
			resp.sendRedirect(encodedURL);
		}
		catch (final URISyntaxException ex)
		{
			throw new ServletException(ex);
		}
	}
	@Override
	protected void doGet(final HttpServletRequest req, final HttpServletResponse resp) throws ServletException,
	        IOException
	{
		try
		{
			final URI uri = new URI(req.getRequestURI());
			final String resolve = uri.getRawPath().replaceFirst("^\\/namesonnodes\\/resolve\\/", "");
			if (resolve.indexOf("::") > 0)
				redirectQName(resolve, resp);
			else
				redirectURI(resolve, resp);
		}
		catch (final URISyntaxException ex)
		{
			throw new ServletException(ex);
		}
	}
	@Override
	protected void doPost(final HttpServletRequest req, final HttpServletResponse resp) throws ServletException,
	        IOException
	{
		if (req.getParameterMap().containsKey("uri"))
			redirectURI(req.getParameter("uri"), resp);
		else if (req.getParameterMap().containsKey("qname"))
			redirectQName(req.getParameter("qname"), resp);
		else if (req.getParameterMap().containsKey("URI"))
			redirectURI(req.getParameter("URI"), resp);
		else if (req.getParameterMap().containsKey("qName"))
			redirectQName(req.getParameter("qName"), resp);
		else if (req.getParameterMap().containsKey("QNAME"))
			redirectQName(req.getParameter("QNAME"), resp);
		else if (req.getParameterMap().containsKey("QName"))
			redirectQName(req.getParameter("QName"), resp);
		else
			throw new ServletException("No URI or QName specified. {" + req.getParameterMap().keySet().toString() + "}");
	}
}
