package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Taxon")]
	public final class Taxon extends AbstractPersistent implements Identified, Summarizeable
	{
		private static const forceInclude_PhyloDefinition:Class = PhyloDefinition;
		private static const forceInclude_RankDefinition:Class = RankDefinition;
		private var _definition:Definition;
		public function Taxon()
		{
			super();
		}
		public function get definition():Definition
		{
			return _definition;
		}
		public function set definition(value:Definition):void
		{
			_definition = assessPropertyValue("definition", value) as Definition;
			flushPendingPropertyEvents();
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span/>;
			if (id > 0)
				xml.appendChild("[Unsaved Taxon]");
			else
				xml.appendChild("Taxon #" + id);
			if (definition)
			{
				xml.appendChild(" := ");
				xml.appendChild(definition.toSummaryHTML());
			}
			return xml.normalize();
		}
	}
}