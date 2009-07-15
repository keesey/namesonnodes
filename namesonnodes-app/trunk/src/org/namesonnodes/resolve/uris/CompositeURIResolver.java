package org.namesonnodes.resolve.uris;

import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public final class CompositeURIResolver implements URIResolver
{
	public final List<URIResolver> resolvers = new ArrayList<URIResolver>();
	public CompositeURIResolver()
	{
		super();
	}
	public CompositeURIResolver(final Collection<URIResolver> resolvers)
	{
		super();
		this.resolvers.addAll(resolvers);
	}
	public URL resolve(final URI uri)
	{
		for (final URIResolver resolver : resolvers)
		{
			final URL url = resolver.resolve(uri);
			if (url != null)
				return url;
		}
		return null;
	}
}
