package org.namesonnodes.html;

import static org.namesonnodes.utils.CollectionUtil.join;
import java.util.List;
import java.util.Set;
import org.namesonnodes.domain.Persistent;

public final class EntityHTMLWriter
{
	public static final EntityHTMLWriter INSTANCE = new EntityHTMLWriter();
	private EntityHTMLWriter()
	{
		super();
	}
	public <E extends Persistent> String write(final E entity, final EntityHTMLAssistant<E> assistant)
	{
		String html = "";
		html += writeXHTMLHeader();
		html += writeHead(entity, assistant);
		html += writeBody(entity, assistant);
		html += "</html>";
		return html;
	}
	private <E extends Persistent> String writeBody(final E entity, final EntityHTMLAssistant<E> assistant)
	{
		String body = "<body>";
		body += assistant.getHeader(entity);
		body += "<div class=\"note\">This page is about an entity in the <i>Names on Nodes</i> database. For more about <i>Names on Nodes</i>, please visit the <a href=\"/namesonnodes\">home page</a>.</div>";
		body += "<div class=\"section\">" + assistant.getAbstract(entity) + "</div>";
		body += writeLinks("Related Entities", assistant.getEntityLinks(entity),
		        "This entity does not appear to be related to other entities.");
		body += writeLinks("External Links", assistant.getExternalLinks(entity), "This entity has no external links.");
		body += assistant.getExtraContent(entity);
		body += writeGenericInformation(entity, assistant);
		body += "</body>";
		return body;
	}
	private <E extends Persistent> String writeGenericInformation(final E entity, final EntityHTMLAssistant<E> assistant)
	{
		String section = "<div class=\"info\">";
		section += "<div>Canonical Qualified Name: <code>http://namesonnodes.org::" + assistant.getTableName() + ":"
		        + entity.getId() + "</code></div>";
		section += "<div>Class: " + assistant.getClassName() + "</div>";
		section += "<div>ID: " + entity.getId() + "</div>";
		section += "<div>Version: " + entity.getVersion() + "</div>";
		section += "</div>";
		return section;
	}
	private <E extends Persistent> String writeHead(final E entity, final EntityHTMLAssistant<E> assistant)
	{
		String head = "<head>";
		head += "<title>Names on Nodes.&mdash;" + assistant.getName(entity) + " [" + assistant.getClassName()
		        + "]</title>";
		head += "<meta http-equiv=\"Content-Language\" content=\"en\" />";
		head += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
		head += "<meta http-equiv=\"PICS-Label\" content=\"(PICS-1.1 &quot;http://vancouver-webpages.com/VWP1.0/&quot; l gen true comment &quot;VWP1.0&quot; by &quot;keesey@gmail.com&quot; on &quot;2009.06.12T11:31-0700&quot; for &quot;http://namesonnodes.org/&quot; r (Gam -1 V 0 Env 0 SF 0 Com 1 Can 0 Edu -1 S 0 P 0 Tol 0 MC 0 ))\" />";
		head += "<meta name=\"Author\" content=\"T. Michael Keesey\" />";
		head += "<meta name=\"Description\" content=\"" + assistant.getDescription(entity) + "\" />";
		head += "<meta name=\"Generator\" content=\"Java\" />";
		final Set<String> keywords = assistant.getKeywords(entity);
		keywords.add("biological");
		keywords.add("biology");
		keywords.add("hierarchy");
		keywords.add("names");
		keywords.add("Names on Nodes");
		keywords.add("nodes");
		keywords.add("nomenclature");
		head += "<meta name=\"Keywords\" content=\"" + join(keywords, ",") + "\" />";
		head += "<style type=\"text/css\">\n";
		head += "body {margin:2em;}\n";
		head += "h1 {font-weight:bold;text-align:center;font-size:150%;font-variant:small-caps}\n";
		head += "h2 {font-weight:normal;text-align:center;font-size:120%;font-variant:small-caps}\n";
		head += "h3 {font-weight:normal;font-style:italic;font-variant:small-caps;margin-left:-0.5em;margin-top:-0.5em;}\n";
		head += ".info, .note, .section {margin:10px;padding:1em;border:1px solid;}\n";
		head += ".info {font-size:75%}\n";
		head += ".note {font-size:90%}\n";
		head += ".section {}\n";
		head += "</style>";
		head += "</head>";
		return head;
	}
	private String writeLinks(final String title, final List<Link> links, final String noItemsText)
	{
		if (links == null || links.isEmpty())
			return "<div class=\"note\">" + noItemsText + "</div>";
		String section = "<div class=\"section\">";
		section += "<h3>" + title + "</h3>";
		section += "<ul>";
		for (final Link link : links)
			section += "<li>" + link.write() + "</li>";
		section += "</ul></div>";
		return section;
	}
	private String writeXHTMLHeader()
	{
		return "<?xml version=\"1.0\"?>\n<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\" xml:lang=\"en\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/1999/xhtml http://www.w3.org/2002/08/xhtml/xhtml1-strict.xsd\">";
	}
}
