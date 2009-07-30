package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.DistanceRow")]
	public final class DistanceRow extends AbstractPersistent
	{
		private var _a:TaxonIdentifier;
		private var _b:TaxonIdentifier;
		private var _distance:Number;
		public function DistanceRow()
		{
			super();
		}
		public function get a():TaxonIdentifier
		{
			return _a;
		}
		public function set a(v:TaxonIdentifier):void
		{
			_a = assessPropertyValue("a", v) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		public function get b():TaxonIdentifier
		{
			return _b;
		}
		public function set b(v:TaxonIdentifier):void
		{
			_b = assessPropertyValue("b", v) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		public function get distance():Number
		{
			return _distance;
		}
		public function set distance(v:Number):void
		{
			_distance = assessPropertyValue("distance", v) as Number;
			flushPendingPropertyEvents();
		}
		public static function create(a:TaxonIdentifier, b:TaxonIdentifier, distance:Number):DistanceRow
		{
			const v:DistanceRow = new DistanceRow();
			v.a = a;
			v.b = b;
			v.distance = distance;
			return v;
		}
	}
}