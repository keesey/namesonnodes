package org.namesonnodes.domain.entities
{
	
	
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
		public static function create(authority:AuthorityIdentifier, label:Label, localName:String, entity:Taxon):TaxonIdentifier
		{
			const v:TaxonIdentifier = new TaxonIdentifier();
			v.authority = authority;
			v.entity = entity;
			v.label = label;
			v.localName = localName;
			v.updateQName();
			return v;
		}
	}
}