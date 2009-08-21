package org.namesonnodes.domain.collections
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.relate.Order;
	import a3lbmonkeybrain.brainstem.relate.Ordered;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class Node implements Ordered
	{
		private static const NAMESPACE_PREFIXES:Dictionary = new Dictionary();
		private const _identifiers:MutableSet = new HashSet();
		private const _taxa:MutableSet = new HashSet();
		public function Node()
		{
			super();
		}
		public static function registerPrefix(ns:Namespace):void
		{
			NAMESPACE_PREFIXES[ns.uri] = ns.prefix;
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
		public function equals(v:Object):Boolean
		{
			if (this == v)
				return true;
			if (v is Node)
				return Node(v)._taxa.equals(_taxa);
			return false;
		}
		public function findOrder(v:Object):int
		{
			if (equals(v))
				return 0;
			if (v is Node)
			{
				const s:String = toString();
				const vs:String = v.toString();
				if (s == vs)
					return 0;
				if (s < vs)
					return -1;
				return 1;
			}
			return 0;
		}
		public function toString():String
		{
			const qNames:Vector.<String> = new Vector.<String>(_identifiers.size);
			var i:uint = 0;
			for each (var identifier:TaxonIdentifier in _identifiers)
			{
				var prefix:* = NAMESPACE_PREFIXES[identifier.authority.uri];
				if (prefix is String)
					qNames[i++] = prefix + "::" + identifier.localName;
				else
					qNames[i++] = identifier.qName.toString();
			}
			return "[Node " + qNames.sort(Order.findOrder).join(" ") + "]";
		}
	}
}