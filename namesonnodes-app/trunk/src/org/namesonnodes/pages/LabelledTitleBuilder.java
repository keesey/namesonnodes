package org.namesonnodes.pages;

import org.namesonnodes.domain.entities.Labelled;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public final class LabelledTitleBuilder<E extends Labelled> implements TitleBuilder<E>
{
	public void buildTitleElement(final Document doc, final Element container, final E entity) throws PageException
	{
		final Element nameDiv = doc.createElement("div");
		nameDiv.setAttribute("class", "name");
		if (entity.getLabel().getItalics())
			nameDiv.setAttribute("style", "font-style: italic;");
		nameDiv.setTextContent(entity.getLabel().getName());
		container.appendChild(nameDiv);
		if (entity.getLabel().getAbbr() != null)
		{
			final Element abbrDiv = doc.createElement("div");
			abbrDiv.setAttribute("class", "abbr");
			if (entity.getLabel().getItalics())
				nameDiv.setAttribute("style", "font-style: italic;");
			nameDiv.setTextContent(entity.getLabel().getAbbr());
			container.appendChild(abbrDiv);
		}
	}
	public String getPageTitle(final E entity) throws PageException
	{
		return entity.getLabel().shortestLabel();
	}
}
