package org.namesonnodes.domain.summaries
{
	import org.namesonnodes.w3c.xhtml.convertXMLToSparkHTML;

	public function summarize(entity:Object):String
	{
		if (entity == null)
			return "[No Entity]";
		var xml:XML = null;
		if (entity is Summarizeable)
			xml = Summarizeable(entity).toSummaryHTML();
		else if (entity is SummaryItem)
			xml = SummaryItem(entity).textHTML;
		else
			return "[Unknown Type of Entity]";
		convertXMLToSparkHTML(xml);
		XML.prettyPrinting = false;
		return xml.toXMLString();
	}
}