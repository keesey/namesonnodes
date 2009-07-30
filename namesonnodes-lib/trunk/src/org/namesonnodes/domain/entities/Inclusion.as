package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Inclusion")]
	public final class Inclusion extends AbstractPersistent implements Summarizeable
	{
		private var _subset:TaxonIdentifier;
		private var _superset:TaxonIdentifier;
		public function Inclusion()
		{
			super();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get subset():TaxonIdentifier
		{
			return _subset;
		}
		public function set subset(value:TaxonIdentifier):void
		{
			_subset = assessPropertyValue("subset", value) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get superset():TaxonIdentifier
		{
			return _superset;
		}
		public function set superset(value:TaxonIdentifier):void
		{
			_superset = assessPropertyValue("superset", value) as TaxonIdentifier;
			flushPendingPropertyEvents();
		}
		public static function create(superset:TaxonIdentifier, subset:TaxonIdentifier):Inclusion
		{
			const v:Inclusion = new Inclusion();
			v.superset = superset;
			v.subset = subset;
			return v;
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span/>;
			xml.appendChild(superset ? superset.toSummaryHTML() : "[No Superset]");
			xml.appendChild(" ⊆ ");
			xml.appendChild(subset ? subset.toSummaryHTML() : "[No Subset]");
			return xml.normalize();
		}
	}
}