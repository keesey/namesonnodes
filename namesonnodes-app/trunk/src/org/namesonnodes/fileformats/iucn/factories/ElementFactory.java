package org.namesonnodes.fileformats.iucn.factories;

import org.w3c.dom.Element;

public interface ElementFactory<T>
{
	public T create(Element element) throws ElementException;
}
