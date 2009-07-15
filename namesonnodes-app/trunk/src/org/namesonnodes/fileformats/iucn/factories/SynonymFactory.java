package org.namesonnodes.fileformats.iucn.factories;

import java.util.HashMap;
import java.util.Map;
import org.namesonnodes.fileformats.iucn.model.Synonym;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public final class SynonymFactory implements ElementFactory<Synonym>
{
	private static class AuthoritySetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.authority = propertyValue;
		}
	}
	private static class GenusNameSetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.genusName = propertyValue;
		}
	}
	private static class InfraAuthoritySetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.infraAuthority = propertyValue;
		}
	}
	private static class InfraNameSetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.infraName = propertyValue;
		}
	}
	private static class InfraRankSetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.infraRank = propertyValue;
		}
	}
	private static class ScientificNameSetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.scientificName = propertyValue;
		}
	}
	private static class SpeciesNameSetter implements PropertySetter<Synonym, String>
	{
		public void setProperty(final Synonym element, final String propertyValue)
		{
			element.speciesName = propertyValue;
		}
	}
	private static final Map<String, PropertySetter<Synonym, String>> SETTER_MAP = new HashMap<String, PropertySetter<Synonym, String>>();
	static
	{
		SETTER_MAP.put("authority", new AuthoritySetter());
		SETTER_MAP.put("genus_name", new GenusNameSetter());
		SETTER_MAP.put("infra_authority", new InfraAuthoritySetter());
		SETTER_MAP.put("infra_name", new InfraNameSetter());
		SETTER_MAP.put("infra_rank", new InfraRankSetter());
		SETTER_MAP.put("scientific_name", new ScientificNameSetter());
		SETTER_MAP.put("species_name", new SpeciesNameSetter());
	}
	public Synonym create(final Element element) throws ElementException
	{
		final Synonym synonym = new Synonym();
		final NodeList childNodes = element.getChildNodes();
		final int n = childNodes.getLength();
		for (int i = 0; i < n; ++i)
		{
			final Node childNode = childNodes.item(i);
			if (childNode.getNodeType() == Node.ELEMENT_NODE)
			{
				final String nodeName = childNode.getLocalName();
				try
				{
					SETTER_MAP.get(nodeName).setProperty(synonym, childNode.getTextContent());
				}
				catch (final NullPointerException ex)
				{
					throw new ElementException("Unrecognized child element ('" + nodeName + "') in '"
					        + element.getNodeName() + "' element.");
				}
			}
		}
		return synonym;
	}
}
