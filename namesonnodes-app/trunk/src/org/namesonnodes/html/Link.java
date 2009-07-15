package org.namesonnodes.html;

public final class Link
{
	public String url;
	public String linkText;
	public String afterText;
	public Link()
	{
		super();
	}
	public Link(final String url)
	{
		super();
		this.url = url;
	}
	public Link(final String url, final String linkText)
	{
		super();
		this.url = url;
		this.linkText = linkText;
	}
	public Link(final String url, final String linkText, final String afterText)
	{
		super();
		this.url = url;
		this.linkText = linkText;
		this.afterText = afterText;
	}
	public String write()
	{
		String html = "";
		if (url != null && url != "")
			html += "<a href=\"" + url + "\">";
		if (linkText != null)
			html += linkText;
		if (url != null && url != "")
			html += "</a>";
		if (afterText != null)
			html += afterText;
		return html;
	}
}
