package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Heredity")]
	public final class Heredity extends AbstractPersistent implements Summarizeable
	{
		private var _predecessor:TaxonIdentifier;
		private var _successor:TaxonIdentifier;
		private var _weight:Number;
		public function Heredity()
		{
			super();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get predecessor():TaxonIdentifier
		{
			return _predecessor;
		}
		public function set predecessor(value:TaxonIdentifier):void
		{
			_predecessor = assessPropertyValue("predecessor", value) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get successor():TaxonIdentifier
		{
			return _successor;
		}
		public function set successor(value:TaxonIdentifier):void
		{
			_successor = assessPropertyValue("successor", value) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		public function get weight():Number
		{
			return _weight;
		}
		public function set weight(value:Number):void
		{
			_weight = assessPropertyValue("weight", value) as Number;
			flushPendingPropertyEvents();
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span/>;
			xml.appendChild(predecessor ? predecessor.toSummaryHTML() : "[No Predecessor]");
			xml.appendChild(" ≼ ");
			xml.appendChild(successor ? successor.toSummaryHTML() : "[No Successor]");
			return xml.normalize();
		}
	}
}