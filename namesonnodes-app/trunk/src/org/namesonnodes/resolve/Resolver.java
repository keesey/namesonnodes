package org.namesonnodes.resolve;

import java.net.URL;

public interface Resolver<T>
{
	public URL resolve(T identifier);
}