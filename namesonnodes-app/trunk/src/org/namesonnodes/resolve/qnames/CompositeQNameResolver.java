package org.namesonnodes.resolve.qnames;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public final class CompositeQNameResolver implements QNameResolver
{
	public final List<QNameResolver> resolvers = new ArrayList<QNameResolver>();
	public CompositeQNameResolver()
	{
		super();
	}
	public CompositeQNameResolver(final Collection<QNameResolver> resolvers)
	{
		super();
		this.resolvers.addAll(resolvers);
	}
	public URL resolve(final QName qName)
	{
		for (final QNameResolver resolver : resolvers)
		{
			final URL url = resolver.resolve(qName);
			if (url != null)
				return url;
		}
		return null;
	}
}
