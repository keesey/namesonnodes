package org.namesonnodes.fileformats.iucn.factories;

import java.util.HashSet;
import java.util.Set;
import org.namesonnodes.fileformats.iucn.model.Species;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public final class ExportReader
{
	public Set<Species> read(final Document document) throws ElementException
	{
		final Element root = document.getDocumentElement();
		if (!root.getNodeName().equals("export"))
			throw new ElementException("Expected 'export' element; found '" + root.getNodeName() + "'.");
		final Set<Species> export = new HashSet<Species>();
		final NodeList childNodes = root.getChildNodes();
		final int n = childNodes.getLength();
		final SpeciesFactory factory = new SpeciesFactory();
		for (int i = 0; i < n; ++i)
		{
			final Node child = childNodes.item(i);
			if (child.getNodeType() == Node.ELEMENT_NODE && child.getNodeName().equals("species"))
			{
				final Species species = factory.create((Element) child);
				export.add(species);
			}
		}
		return export;
	}
}
