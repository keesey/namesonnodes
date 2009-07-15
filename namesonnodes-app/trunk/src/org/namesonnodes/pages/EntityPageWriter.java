package org.namesonnodes.pages;

import org.namesonnodes.domain.Persistent;
import org.w3c.dom.Document;

public interface EntityPageWriter<E extends Persistent>
{
	public Document write(E entity) throws PageException;
}
