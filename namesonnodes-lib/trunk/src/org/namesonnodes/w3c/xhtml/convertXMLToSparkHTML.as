package org.namesonnodes.w3c.xhtml
{
	import a3lbmonkeybrain.brainstem.w3c.xml.XMLNodeKind;

	public function convertXMLToSparkHTML(xml:XML):void
	{
		const topLevel:Boolean = xml.parent() == null;
		if (xml.nodeKind() != XMLNodeKind.ELEMENT)
			return;
		if (xml.localName() == "span")
			xml.setLocalName("div");
		else if (xml.localName() == "i")
		{
			xml.setLocalName("span");
			xml.@fontStyle = "italic";
		}
		for each (var child:XML in xml.children())
			convertXMLToSparkHTML(child);
	}
}