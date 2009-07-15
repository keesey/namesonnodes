package org.namesonnodes.validators.xml;

import java.io.IOException;
import java.io.Serializable;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.validation.Schema;
import org.hibernate.validator.Validator;
import org.namesonnodes.utils.DocumentUtil;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public final class XMLValidator implements Serializable, Validator<XML>
{
	private static final long serialVersionUID = 1L;
	private javax.xml.validation.Validator xmlValidator;
	private String rootNodeName = null;
	private String targetNamespace = null;
	public void initialize(final String targetNamespace, final String rootNodeName)
	{
		this.rootNodeName = rootNodeName == "" ? null : rootNodeName;
		this.targetNamespace = targetNamespace;
		final Schema schema = SchemaDictionary.getSchema(targetNamespace);
		if (schema == null)
			throw new IllegalArgumentException("There is no schema for the namespace \"" + targetNamespace + "\".");
		xmlValidator = schema.newValidator();
	}
	public void initialize(final XML parameters)
	{
		initialize(parameters.targetNamespace(), parameters.rootNodeName());
	}
	public boolean isValid(final Object value)
	{
		if (value instanceof String)
		{
			String source = (String) value;
			if (rootNodeName != null && rootNodeName.length() != 0)
				source = "<" + rootNodeName + " xmlns=\"" + targetNamespace + "\">" + source + "</" + rootNodeName
				        + ">";
			Document document;
			try
			{
				document = DocumentUtil.read(source);
			}
			catch (final IOException ex)
			{
				ex.printStackTrace();
				return false;
			}
			catch (final ParserConfigurationException ex)
			{
				ex.printStackTrace();
				return false;
			}
			catch (final SAXException ex)
			{
				ex.printStackTrace();
				return false;
			}
			return isValidDocument(document);
		}
		else if (value instanceof Document)
			return isValidDocument((Document) value);
		return false;
	}
	private boolean isValidDocument(final Document document)
	{
		try
		{
			xmlValidator.validate(new DOMSource(document));
		}
		catch (final SAXException ex)
		{
			ex.printStackTrace();
			return false;
		}
		catch (final IOException ex)
		{
			ex.printStackTrace();
			return false;
		}
		return true;
	}
}
