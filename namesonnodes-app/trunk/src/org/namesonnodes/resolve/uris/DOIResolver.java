package org.namesonnodes.resolve.uris;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

public final class DOIResolver implements URIResolver
{
	public URL resolve(final URI uri)
	{
		if (uri.getScheme() == null || uri.getSchemeSpecificPart() == null)
			return null;
		if (uri.getScheme().equals("urn") && uri.getSchemeSpecificPart().startsWith("doi:"))
			try
			{
				return new URL("http://dx.doi.org/" + uri.getSchemeSpecificPart().substring(4));
			}
			catch (final MalformedURLException ex)
			{
				throw new RuntimeException(ex);
			}
		return null;
	}
}
