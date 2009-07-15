package org.namesonnodes.pages;

import java.io.IOException;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.utils.DocumentUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

public abstract class AbstractPageWriter<E extends Persistent> implements EntityPageWriter<E>
{
	// :TODO: add stylesheet
	private static final String BASE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
	        + "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n"
	        + "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/MarkUp/SCHEMA/xhtml11.xsd\" xml:lang=\"en\">"
	        + "<head>" + "<meta name=\"author\" content=\"T. Michael Keesey\"/>" + "</head><body/></html>";
	protected static <E extends Persistent> Element buildEntityLink(final Document doc, final E entity,
	        final Class<E> entityClass)
	{
		final Element a = doc.createElement("a");
		a.setAttribute("href", "/entity/" + entityClass.getSimpleName() + ":" + entity.getId());
		return a;
	}
	protected abstract void buildContentElement(final Document doc, final Element container, final E entity)
	        throws PageException;
	protected abstract void buildTitleElement(final Document doc, final Element container, final E entity)
	        throws PageException;
	protected abstract String getPageTitle(final E entity) throws PageException;
	public Document write(final E entity) throws PageException
	{
		Document doc;
		try
		{
			doc = DocumentUtil.read(BASE);
		}
		catch (final IOException ex)
		{
			throw new PageException(ex);
		}
		catch (final ParserConfigurationException ex)
		{
			throw new PageException(ex);
		}
		catch (final SAXException ex)
		{
			throw new PageException(ex);
		}
		final List<Element> childElements = DocumentUtil.findChildElements(doc.getDocumentElement());
		final Element head = childElements.get(0);
		final Element body = childElements.get(1);
		head.appendChild(doc.createElement("title")).setTextContent(getPageTitle(entity));
		final Element titleDiv = (Element) body.appendChild(doc.createElement("div"));
		titleDiv.setAttribute("id", "title");
		buildTitleElement(doc, titleDiv, entity);
		final Element contentDiv = (Element) body.appendChild(doc.createElement("div"));
		contentDiv.setAttribute("id", "content");
		buildContentElement(doc, contentDiv, entity);
		return doc;
	}
}
