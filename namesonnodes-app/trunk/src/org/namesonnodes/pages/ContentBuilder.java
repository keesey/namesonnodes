package org.namesonnodes.pages;

import org.namesonnodes.domain.Persistent;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public interface ContentBuilder<E extends Persistent>
{
	public void buildContentElement(final Document doc, final Element container, final E entity) throws PageException;
}
