package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.PhyloDefinition")]
	public final class PhyloDefinition extends AbstractPersistent implements Definition
	{
		private const _specifiers:ArrayCollection = createEntityCollection(TaxonIdentifier);
		private var _formula:XML;
		private var _prose:XML;
		public function PhyloDefinition()
		{
			super();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.XMLValidator", required = true)]
		public function get formula():XML
		{
			return _formula;
		}
		public function set formula(value:XML):void
		{
			_formula = assessPropertyValue("formula", value) as XML;
			flushPendingPropertyEvents();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.XMLValidator", required = true)]
		public function get prose():XML
		{
			return _prose;
		}
		public function set prose(value:XML):void
		{
			_prose = assessPropertyValue("prose", value) as XML;
			flushPendingPropertyEvents();
		}
		public function get specifiers():ArrayCollection
		{
			return _specifiers;
		}
		public function set specifiers(value:ArrayCollection):void
		{
			_specifiers.source = value ? value.source : [];
			_specifiers.refresh();
		}
		public function toSummaryHTML():XML
		{
			return prose;
		}
	}
}