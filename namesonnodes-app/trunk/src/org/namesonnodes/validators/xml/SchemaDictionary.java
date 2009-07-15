package org.namesonnodes.validators.xml;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import org.jdom.Namespace;
import org.namesonnodes.utils.DocumentUtil;
import org.namesonnodes.w3c.HTML;
import org.namesonnodes.w3c.MathML;
import org.xml.sax.SAXException;

public final class SchemaDictionary
{
	private static final Map<Namespace, Schema> map = new HashMap<Namespace, Schema>();
	private static final String XHTML_TEXT_XSD_SOURCE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
	        + "<xs:schema version=\"1.0\"\n" + "xml:lang=\"en\"\n" + "xmlns:xs=\"http://www.w3.org/2001/XMLSchema\"\n"
	        + "xmlns=\"http://www.w3.org/1999/xhtml\"\n" + "targetNamespace=\"http://www.w3.org/1999/xhtml\"\n"
	        + "xmlns:xml=\"http://www.w3.org/XML/1998/namespace\"\n" + "elementFormDefault=\"qualified\">\n"
	        + "<xs:element name=\"i\" type=\"text\"/>\n" + "<xs:element name=\"b\" type=\"text\"/>\n"
	        + "<xs:element name=\"u\" type=\"text\"/>\n" + "<xs:element name=\"span\" type=\"text\"/>\n"
	        + "<xs:complexType name=\"text\" mixed=\"true\">\n"
	        + "<xs:choice maxOccurs=\"unbounded\" minOccurs=\"0\">\n" + "<xs:element ref=\"b\"></xs:element>\n"
	        + "<xs:element ref=\"i\"></xs:element>\n" + "<xs:element ref=\"u\"></xs:element>\n" + "</xs:choice>\n"
	        + "</xs:complexType>\n" + "</xs:schema>";
	static
	{
		try
		{
			final SchemaFactory schemaFactory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
			map.put(HTML.NAMESPACE, schemaFactory.newSchema(new DOMSource(DocumentUtil.read(XHTML_TEXT_XSD_SOURCE))));
			map.put(MathML.NAMESPACE, schemaFactory.newSchema(new StreamSource(
			        "http://www.w3.org/Math/XMLSchema/mathml2/mathml2.xsd")));
		}
		catch (final SAXException ex)
		{
			ex.printStackTrace();
		}
		catch (final IOException ex)
		{
			ex.printStackTrace();
		}
		catch (final ParserConfigurationException ex)
		{
			ex.printStackTrace();
		}
	}
	public static Schema getSchema(final Namespace namespace)
	{
		return map.get(namespace);
	}
	public static Schema getSchema(final String namespaceURI)
	{
		return map.get(Namespace.getNamespace(namespaceURI));
	}
}
