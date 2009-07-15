package org.namesonnodes.domain.summaries;

import static org.namesonnodes.utils.DocumentUtil.read;
import java.io.IOException;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public final class SummaryItem
{
	private String className;
	private Document textHTML;
	private int id;
	public SummaryItem()
	{
		super();
	}
	public SummaryItem(final int id)
	{
		super();
		this.id = id;
	}
	public SummaryItem(final int id, final Document textHTML)
	{
		super();
		this.id = id;
		this.textHTML = textHTML;
	}
	public SummaryItem(final int id, final Document textHTML, final String className)
	{
		this(id, textHTML);
		this.className = className;
	}
	public SummaryItem(final int id, final String textHTML) throws IOException, ParserConfigurationException,
	        SAXException
	{
		super();
		this.id = id;
		this.textHTML = read("<span>" + textHTML + "</span>");
	}
	public SummaryItem(final int id, final String textHTML, final String className) throws IOException,
	        ParserConfigurationException, SAXException
	{
		this(id, textHTML);
		this.className = className;
	}
	public String getClassName()
	{
		return className;
	}
	public final int getId()
	{
		return id;
	}
	public final Document getTextHTML() throws IOException, ParserConfigurationException, SAXException
	{
		if (textHTML == null)
			setTextHTML(read("<span/>"));
		return textHTML;
	}
	public void setClassName(final String className)
	{
		this.className = className;
	}
	public final void setId(final int id)
	{
		this.id = id;
	}
	public final void setTextHTML(final Document textHTML)
	{
		this.textHTML = textHTML;
	}
}
