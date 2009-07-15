package org.namesonnodes.utils;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Contains methods for handling W3C DOM documents.
 * 
 * @author T. Michael Keesey
 * @see org.w3c.dom.Document
 */
public final class DocumentUtil
{
	public static final DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
	private static final Transformer transformer;
	static
	{
		builderFactory.setNamespaceAware(true);
		try
		{
			transformer = TransformerFactory.newInstance().newTransformer();
		}
		catch (final TransformerConfigurationException ex)
		{
			throw new RuntimeException(ex);
		}
		transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		transformer.setOutputProperty(OutputKeys.INDENT, "no");
		transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		transformer.setOutputProperty(OutputKeys.MEDIA_TYPE, "text/xml");
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	}
	public static String encode(final String text)
	{
		return text.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
	}
	public static List<Element> findChildElements(final Element element)
	{
		final NodeList nodes = element.getChildNodes();
		final int n = nodes.getLength();
		final List<Element> children = new ArrayList<Element>();
		for (int i = 0; i < n; ++i)
		{
			final Node node = nodes.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE)
				children.add((Element) node);
		}
		return children;
	}
	/**
	 * Reads a document from a string.
	 * 
	 * @param s
	 *            Source string.
	 * @return Document object.
	 * @throws IOException
	 *             If an I/O error occurs.
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 *             If {@code s} is not properly formatted.
	 */
	public static Document read(final String s) throws IOException, ParserConfigurationException, SAXException
	{
		if (s == null)
			return null;
		final Document document = builderFactory.newDocumentBuilder().parse(new InputSource(new StringReader(s)));
		return document;
	}
	/**
	 * Converts a document object to a string.
	 * 
	 * @param document
	 *            Document object.
	 * @return Source string.
	 */
	public static String write(final Document document) throws TransformerException
	{
		if (document == null)
			return null;
		final Writer writer = new StringWriter();
		transformer.transform(new DOMSource(document), new StreamResult(writer));
		return writer.toString();
	}
}
