package org.namesonnodes.pages;

import org.namesonnodes.domain.Persistent;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public interface TitleBuilder<E extends Persistent>
{
	public void buildTitleElement(final Document doc, final Element container, final E entity) throws PageException;
	public String getPageTitle(final E entity) throws PageException;
}
