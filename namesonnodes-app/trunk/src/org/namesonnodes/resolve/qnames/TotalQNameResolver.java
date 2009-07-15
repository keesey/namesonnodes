package org.namesonnodes.resolve.qnames;

import java.net.URL;
import org.hibernate.Session;

public final class TotalQNameResolver implements QNameResolver
{
	private final CompositeQNameResolver composite = new CompositeQNameResolver();
	public TotalQNameResolver(final Session session)
	{
		super();
		composite.resolvers.add(NamesOnNodesQNameResolver.INSTANCE);
		composite.resolvers.add(new IUCNRedListQNameResolver(session));
		composite.resolvers.add(new TaxonSearchQNameResolver(session));
		composite.resolvers.add(new ShallowQNameResolver());
	}
	public URL resolve(final QName qName)
	{
		return composite.resolve(qName);
	}
}
