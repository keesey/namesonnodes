package org.namesonnodes.resolve.qnames;

import java.net.MalformedURLException;
import java.net.URL;

public final class NamesOnNodesQNameResolver implements QNameResolver
{
	private static final String NAME_ON_NODES_URI = "http://namesonnodes.org";
	public static final NamesOnNodesQNameResolver INSTANCE = new NamesOnNodesQNameResolver();
	private NamesOnNodesQNameResolver()
	{
		super();
	}
	public URL resolve(final QName name)
	{
		if (name.getUri().toString().equals(NAME_ON_NODES_URI))
		{
			if (!name.getLocalName().matches("^[a-z]+:\\d+$"))
				throw new IllegalArgumentException("Invalid Names on Nodes entity specification: "
				        + name.getLocalName());
			try
			{
				return new URL("http://namesonnodes.org:8080/namesonnodes/entity/" + name.getLocalName());
			}
			catch (final MalformedURLException e)
			{
				throw new RuntimeException(e);
			}
		}
		return null;
	}
}
