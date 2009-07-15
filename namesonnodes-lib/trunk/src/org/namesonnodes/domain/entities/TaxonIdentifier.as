package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.brainstem.strings.clean;
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.TaxonIdentifier")]
	public final dynamic class TaxonIdentifier extends AbstractQualified
	{
		private var _entity:Taxon;
		public function TaxonIdentifier()
		{
			super();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get entity():Taxon
		{
			return _entity;
		}
		public function set entity(value:Taxon):void
		{
			_entity = assessPropertyValue("entity", value) as Taxon;
			flushPendingPropertyEvents();
		}
	}
}