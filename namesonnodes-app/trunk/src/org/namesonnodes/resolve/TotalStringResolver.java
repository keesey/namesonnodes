package org.namesonnodes.resolve;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import org.hibernate.Session;
import org.namesonnodes.resolve.qnames.QName;
import org.namesonnodes.resolve.qnames.TotalQNameResolver;
import org.namesonnodes.resolve.uris.TotalURIResolver;

public final class TotalStringResolver implements Resolver<String>
{
	private final Resolver<QName> qNameResolver;
	public TotalStringResolver(final Session session)
	{
		super();
		qNameResolver = new TotalQNameResolver(session);
	}
	public URL resolve(final String identifier) throws IllegalArgumentException
	{
		if (identifier == null)
			return null;
		try
		{
			if (identifier.indexOf("::") > 0)
				return qNameResolver.resolve(new QName(identifier));
		}
		catch (final URISyntaxException e)
		{
			throw new RuntimeException(e);
		}
		try
		{
			return TotalURIResolver.INSTANCE.resolve(new URI(identifier));
		}
		catch (final URISyntaxException e)
		{
			throw new RuntimeException(e);
		}
	}
}
