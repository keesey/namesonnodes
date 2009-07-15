package org.namesonnodes.fileformats.iucn.factories;

import org.w3c.dom.Element;

public interface ElementReader<T>
{
	public void read(Element element, T value) throws ElementException;
}
