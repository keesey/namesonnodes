package org.namesonnodes.resolve.uris;

import java.net.URI;
import java.net.URL;

public final class TotalURIResolver implements URIResolver
{
	public static final TotalURIResolver INSTANCE = new TotalURIResolver();
	private final CompositeURIResolver composite = new CompositeURIResolver();
	private TotalURIResolver()
	{
		super();
		composite.resolvers.add(new URLResolver());
		composite.resolvers.add(new DOIResolver());
		composite.resolvers.add(new ISBNResolver());
		composite.resolvers.add(new SICIResolver());
		composite.resolvers.add(new SHA1Resolver());
		composite.resolvers.add(new LSIDResolver());
	}
	public URL resolve(final URI uri)
	{
		return composite.resolve(uri);
	}
}
