package org.namesonnodes.fileformats.iucn.factories;

import static org.namesonnodes.fileformats.iucn.model.Assessment.VERSION;
import org.namesonnodes.fileformats.iucn.model.Assessment;
import org.namesonnodes.fileformats.iucn.model.Category;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public final class AssessmentFactory implements ElementFactory<Assessment>
{
	public Assessment create(final Element element) throws ElementException
	{
		if (!element.getAttribute("version").equals(VERSION))
			throw new ElementException("Cannot process categories of versions other than " + VERSION + ".");
		final NodeList categories = element.getElementsByTagName("category");
		if (categories.getLength() != 1)
			throw new ElementException("An '" + element.getNodeName()
			        + "' element requires exactly one 'category' child element.");
		final Category category = Category.getByCode(categories.item(0).getTextContent());
		if (category == null)
			throw new ElementException("Unrecognized category: " + categories.item(0).getTextContent());
		final int year = new Integer(element.getAttribute("year"));
		try
		{
			final Assessment assessment = Assessment.INSTANCE_MAP.get(year).get(category);
			if (assessment == null)
				throw new ElementException("Invalid assessment: year = " + year + "; category = " + category.getCode()
				        + ".");
			return assessment;
		}
		catch (final NullPointerException ex)
		{
			throw new ElementException("Invalid assessment: year = " + year + "; category = " + category.getCode()
			        + ".");
		}
	}
}
