package org.namesonnodes.domain.entities
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Dataset")]
	public final dynamic class Dataset extends AbstractQualified
	{
		private const _heredities:ArrayCollection = createEntityCollection(Heredity);
		private const _inclusions:ArrayCollection = createEntityCollection(Inclusion);
		private const _synonymies:ArrayCollection = createEntityCollection(Synonymy);
		private var _label:Label;
		private var _weightPerGeneration:Number;
		private var _weightPerYear:Number;
		public function Dataset()
		{
			super();
		}
		public function get heredities():ArrayCollection
		{
			return _heredities;
		}
		public function set heredities(value:ArrayCollection):void
		{
			_heredities.source = value ? value.source : [];
			_heredities.refresh();
		}
		public function get inclusions():ArrayCollection
		{
			return _inclusions;
		}
		public function set inclusions(value:ArrayCollection):void
		{
			_inclusions.source = value ? value.source : [];
			_inclusions.refresh();
		}
		public function get synonymies():ArrayCollection
		{
			return _synonymies;
		}
		public function set synonymies(value:ArrayCollection):void
		{
			_synonymies.source = value ? value.source : [];
			_synonymies.refresh();
		}
		public function get weightPerGeneration():Number
		{
			return _weightPerGeneration;
		}
		public function set weightPerGeneration(value:Number):void
		{
			_weightPerGeneration = assessPropertyValue("weightPerGeneration", value) as Number;
			flushPendingPropertyEvents();
		}
		public function get weightPerYear():Number
		{
			return _weightPerYear;
		}
		public function set weightPerYear(value:Number):void
		{
			_weightPerYear = assessPropertyValue("weightPerYear", value) as Number;
			flushPendingPropertyEvents();
		}
		public function hasRelations():Boolean
		{
			return _heredities.length != 0 || _inclusions.length != 0 || _synonymies.length != 0;
		}
	}
}