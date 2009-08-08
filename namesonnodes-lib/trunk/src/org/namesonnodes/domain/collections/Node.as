package org.namesonnodes.domain.collections
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.relate.Order;
	
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
		public function toString():String
		{
			const qNames:Vector.<String> = new Vector.<String>(_identifiers.size);
			var i:uint = 0;
			for each (var identifier:TaxonIdentifier in _identifiers)
				qNames[i++] = identifier.qName.toString();
			return "[Node " + qNames.sort(Order.findOrder).join(" ") + "]";
		}
	}
}