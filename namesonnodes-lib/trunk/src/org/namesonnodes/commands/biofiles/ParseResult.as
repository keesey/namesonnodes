package org.namesonnodes.commands.biofiles
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.Synonymy;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class ParseResult
	{
		public var comments:String = "";
		public var mimeType:String = "text/plain";
		public const datasets:Vector.<Dataset> = new Vector.<Dataset>(); 
		public function ParseResult()
		{
			super();
		}
		public function authorize(authority:AuthorityIdentifier):void
		{
			var taxonIdentifier:TaxonIdentifier;
			for each (taxonIdentifier in taxonIdentifiers)
				taxonIdentifier.authority = authority;
		}
		public function get taxonIdentifiers():FiniteSet
		{
			const identifiers:MutableSet = new HashSet();
			for each (var dataset:Dataset in datasets)
			{
				for each (var heredity:Heredity in dataset.heredities)
				{
					identifiers.add(heredity.predecessor);
					identifiers.add(heredity.successor);
				}
				for each (var inclusion:Inclusion in dataset.inclusions)
				{
					identifiers.add(inclusion.superset);
					identifiers.add(inclusion.subset);
				}
				for each (var synonymy:Synonymy in dataset.synonymies)
					for each (var identifier:TaxonIdentifier in synonymy.synonyms)
						identifiers.add(identifier);
			}
			return identifiers;
		}
	}
}