package org.namesonnodes.fileformats.iucn.factories;

import java.util.HashMap;
import java.util.Map;
import org.namesonnodes.fileformats.iucn.model.Assessment;
import org.namesonnodes.fileformats.iucn.model.CommonName;
import org.namesonnodes.fileformats.iucn.model.Species;
import org.namesonnodes.fileformats.iucn.model.Synonym;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public final class SpeciesFactory implements ElementFactory<Species>
{
	private static class AssessmentReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value) throws ElementException
		{
			value.assessment = ASSESSMENT_FACTORY.create(element);
		}
	}
	private static class AuthorityReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.authority = element.getTextContent();
		}
	}
	private static class ClassNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.className = element.getTextContent();
		}
	}
	private static class CommonNamesReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value) throws ElementException
		{
			final NodeList childNodes = element.getChildNodes();
			final int n = childNodes.getLength();
			for (int i = 0; i < n; ++i)
			{
				final Node child = childNodes.item(i);
				if (child.getNodeType() == Node.ELEMENT_NODE)
					if (child.getNodeName().equals("name"))
						value.commonNames.add(COMMON_NAME_FACTORY.create((Element) child));
					else
						throw new ElementException("Expected 'name' element; found '" + child.getNodeName() + "'.");
			}
			value.authority = element.getTextContent();
		}
	}
	private static class FamilyNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.familyName = element.getTextContent();
		}
	}
	private static class GenusNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.genusName = element.getTextContent();
		}
	}
	private static class KingdomNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.kingdomName = element.getTextContent();
		}
	}
	private static class NullReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
		}
	}
	private static class OrderNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.orderName = element.getTextContent();
		}
	}
	private static class PhylumNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.phylumName = element.getTextContent();
		}
	}
	private static class ScientificNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.scientificName = element.getTextContent();
		}
	}
	private static class SpeciesNameReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value)
		{
			value.speciesName = element.getTextContent();
		}
	}
	private static class SynonymsReader implements ElementReader<Species>
	{
		public void read(final Element element, final Species value) throws ElementException
		{
			final NodeList childNodes = element.getChildNodes();
			final int n = childNodes.getLength();
			for (int i = 0; i < n; ++i)
			{
				final Node child = childNodes.item(i);
				if (child.getNodeType() == Node.ELEMENT_NODE)
					if (child.getNodeName().equals("synonym"))
						value.synonyms.add(SYNONYM_FACTORY.create((Element) child));
					else
						throw new ElementException("Expected 'synonym' element; found '" + child.getNodeName() + "'.");
			}
			value.authority = element.getTextContent();
		}
	}
	private static final ElementFactory<Assessment> ASSESSMENT_FACTORY = new AssessmentFactory();
	private static final ElementFactory<CommonName> COMMON_NAME_FACTORY = new CommonNameFactory();
	private static final Map<String, ElementReader<Species>> READER_MAP = new HashMap<String, ElementReader<Species>>();
	private static final ElementFactory<Synonym> SYNONYM_FACTORY = new SynonymFactory();
	static
	{
		READER_MAP.put("scientific_name", new ScientificNameReader());
		READER_MAP.put("kingdom_name", new KingdomNameReader());
		READER_MAP.put("phylum_name", new PhylumNameReader());
		READER_MAP.put("class_name", new ClassNameReader());
		READER_MAP.put("order_name", new OrderNameReader());
		READER_MAP.put("family_name", new FamilyNameReader());
		READER_MAP.put("genus_name", new GenusNameReader());
		READER_MAP.put("species_name", new SpeciesNameReader());
		READER_MAP.put("authority", new AuthorityReader());
		READER_MAP.put("population", new NullReader());
		READER_MAP.put("assessment", new AssessmentReader());
		READER_MAP.put("common_names", new CommonNamesReader());
		READER_MAP.put("synonyms", new SynonymsReader());
	}
	public Species create(final Element element) throws ElementException
	{
		final Species species = new Species();
		species.id = new Integer(element.getAttribute("id"));
		final NodeList childNodes = element.getChildNodes();
		final int n = childNodes.getLength();
		for (int i = 0; i < n; ++i)
		{
			final Node child = childNodes.item(i);
			if (child.getNodeType() == Node.ELEMENT_NODE)
				try
				{
					READER_MAP.get(child.getNodeName()).read((Element) child, species);
				}
				catch (final NullPointerException ex)
				{
					throw new ElementException("Unexpected node ('" + child.getNodeName() + "') in '"
					        + element.getNodeName() + "' element.");
				}
		}
		return species;
	}
}
