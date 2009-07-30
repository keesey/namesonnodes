package org.namesonnodes.domain.collections
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class Node
	{
		private const _identifiers:MutableSet = new HashSet();
		private const _taxa:MutableSet = new HashSet();
		public function Node()
		{
			super();
		}
		public function get identifiers():FiniteSet
		{
			return _identifiers;
		}
		public function get taxa():FiniteSet
		{
			return _taxa;
		}
		internal function addIdentifier(id:TaxonIdentifier):void
		{
			_identifiers.add(id);
			_taxa.add(id.entity);
		}
	}
}