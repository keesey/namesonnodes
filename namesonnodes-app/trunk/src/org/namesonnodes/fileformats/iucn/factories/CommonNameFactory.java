package org.namesonnodes.fileformats.iucn.factories;

import org.namesonnodes.fileformats.iucn.model.CommonName;
import org.w3c.dom.Element;

public final class CommonNameFactory implements ElementFactory<CommonName>
{
	public CommonName create(final Element element) throws ElementException
	{
		final CommonName commonName = new CommonName();
		commonName.lang = element.getAttribute("lang");
		commonName.name = element.getTextContent();
		return commonName;
	}
}
