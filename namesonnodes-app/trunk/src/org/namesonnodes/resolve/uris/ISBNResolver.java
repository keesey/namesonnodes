package org.namesonnodes.resolve.uris;

import static org.namesonnodes.utils.URIUtil.unescape;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

public final class ISBNResolver implements URIResolver
{
	private static final String URL_FORMAT = "http://www.amazon.com/gp/product/{ISBN}?ie=UTF8&tag=namonnod-20&linkCode=as2&camp=1789&creative=9325&creativeASIN={ISBN}";
	public URL resolve(final URI uri)
	{
		if (uri.getScheme() == null || uri.getSchemeSpecificPart() == null)
			return null;
		if (uri.getScheme().equals("urn")
		        && (uri.getSchemeSpecificPart().startsWith("isbn:") || uri.getSchemeSpecificPart().startsWith("bici:") || uri
		                .getSchemeSpecificPart().startsWith("asin:")))
		{
			String isbn = uri.getSchemeSpecificPart().substring(5);
			if (uri.getSchemeSpecificPart().startsWith("bici:"))
				isbn = unescape(isbn).split("[<(]+")[0];
			isbn = isbn.replaceAll("[^0-9]", "");
			try
			{
				return new URL(URL_FORMAT.replace("{ISBN}", isbn));
			}
			catch (final MalformedURLException ex)
			{
				throw new RuntimeException(ex);
			}
		}
		return null;
	}
}
