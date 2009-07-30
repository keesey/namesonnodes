package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.RankDefinition")]
	public final class RankDefinition extends AbstractPersistent implements Definition
	{
		private const _types:ArrayCollection = createEntityCollection(TaxonIdentifier);
		private var _level:Number;
		private var _rank:String;
		public function RankDefinition()
		{
			super();
		}
		public function get level():Number
		{
			return _level;
		}
		public function set level(value:Number):void
		{
			_level = assessPropertyValue("level", value) as Number;
			flushPendingPropertyEvents();
		}
		[Validator(type = "mx.validators.RegExpValidator", expression = "^[a-z]{1,64}$")]
		public function get rank():String
		{
			return _rank;
		}
		public function set rank(value:String):void
		{
			value = clean(value).toLowerCase();
			_rank = assessPropertyValue("rank", value) as String;
			flushPendingPropertyEvents();
		}
		public function get types():ArrayCollection
		{
			return _types;
		}
		public function set types(value:ArrayCollection):void
		{
			_types.source = value ? value.source : [];
			_types.refresh();
		}
		public static function create(rank:String, level:Number, types:Object = null):RankDefinition
		{
			const v:RankDefinition = new RankDefinition();
			v.rank = rank;
			v.level = level;
			if (types)
				for each (var type:TaxonIdentifier in types)
					v.types.addItem(type);
			return v;
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span>{_rank}(</span>;
			for (var i:uint = 0; i < _types.length; ++i)
			{
				if (i > 0)
					xml.appendChild(", ");
				xml.appendChild(TaxonIdentifier(_types.getItemAt(i)).toSummaryHTML());
			}
			xml.appendChild(")");
			return xml.normalize();
		}
	}
}