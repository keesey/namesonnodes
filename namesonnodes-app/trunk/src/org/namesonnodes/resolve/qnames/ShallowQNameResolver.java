package org.namesonnodes.resolve.qnames;

import java.net.URL;
import org.namesonnodes.resolve.uris.TotalURIResolver;

public final class ShallowQNameResolver implements QNameResolver
{
	public URL resolve(final QName qName)
	{
		return TotalURIResolver.INSTANCE.resolve(qName.getUri());
	}
}
