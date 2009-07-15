package org.namesonnodes.w3c;

import org.jdom.Element;
import org.jdom.Namespace;

/**
 * Contains tools for handling XHTML.
 * 
 * @author T. Michael Keesey
 * @see http://www.w3.org/TR/xhtml1/
 */
public final class HTML
{
	/**
	 * The namespace localName for XHTML.
	 */
	public static final Namespace NAMESPACE = Namespace.getNamespace("http://www.w3.org/1999/xhtml");
	/**
	 * Creates an XHTML element with a {@code class} attribute.
	 * <p>
	 * As an example,
	 * <code>HTML.createClassElement(&quot;span&quot;, &quot;nomen&quot;)</code>
	 * yields <code>&lt;span class=&quot;nomen&quot;/&gt;</code>.
	 * </p>
	 * 
	 * @param name
	 *            Name of the element (for example, <code>"span"</code>).
	 * @param className
	 *            Name of the class.
	 * @return An XHTML element with the specified name and of the specified
	 *         class.
	 */
	public static Element createClassElement(final String name, final String className)
	{
		return new Element(name, HTML.NAMESPACE).setAttribute("class", className);
	}
	/**
	 * (private)
	 */
	private HTML()
	{
	}
}
