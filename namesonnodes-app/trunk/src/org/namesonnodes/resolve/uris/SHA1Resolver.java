package org.namesonnodes.resolve.uris;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

public final class SHA1Resolver implements URIResolver
{
	public URL resolve(final URI uri)
	{
		if (uri.getScheme() == null || uri.getSchemeSpecificPart() == null)
			return null;
		if (uri.getScheme().equals("urn") && uri.getSchemeSpecificPart().startsWith("sha1:"))
		{
			final String sourceHash = uri.getSchemeSpecificPart().substring(5).toLowerCase();
			if (sourceHash.matches("[a-z0-9]{40}"))
				try
				{
					return new URL("http://namesonnodes.org/biofile/?sourceHash=" + sourceHash);
				}
				catch (final MalformedURLException ex)
				{
					throw new RuntimeException(ex);
				}
		}
		return null;
	}
}
