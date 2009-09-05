package org.namesonnodes.math.entities
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteCollection;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.filter.filterType;
	import a3lbmonkeybrain.calculia.collections.sets.SetDifference;
	import a3lbmonkeybrain.calculia.collections.sets.SetIntersection;
	import a3lbmonkeybrain.calculia.collections.sets.SetUnion;
	
	import flash.errors.IllegalOperationError;
	
	import org.namesonnodes.domain.nodes.Node;
	
	public final class Taxon implements Set
	{
		private var finestNodes:Set = EmptySet.INSTANCE;
		public function Taxon()
		{
			super();
		}
		public function get numNodes():uint
		{
			if (finestNodes is FiniteCollection)
				return FiniteCollection(finestNodes).size;
			throw new IllegalOperationError();
		}
		public static function fromFinestNodes(nodes:Object):Taxon
		{
			const taxon:Taxon = new Taxon();
			taxon.finestNodes = HashSet.fromObject(nodes).filter(filterType(Node)) as Set;
			return taxon;
		}
		public function diff(subtrahend:Object):Set
		{
			if (subtrahend is Taxon)
			{
				const result:Taxon = new Taxon();
				result.finestNodes = finestNodes.diff(Taxon(subtrahend).finestNodes);
				return result;
			}
			else if (subtrahend is Set)
			{
				if (Set(subtrahend).empty)
					return this;
				return new SetDifference(this, subtrahend as Set);
			}
			return new SetDifference(this, HashSet.fromObject(subtrahend));
		}
		public function equals(value:Object):Boolean
		{
			return value is Taxon && finestNodes.equals(Taxon(value).finestNodes);
		}
		public function intersect(operand:Object):Set
		{
			if (operand is Taxon)
			{
				const result:Taxon = new Taxon();
				result.finestNodes = finestNodes.intersect(Taxon(operand).finestNodes);
				return result;
			}
			else if (operand is Set)
			{
				if (Set(operand).empty)
					return operand as Set;
				return new SetIntersection(this, operand as Set);
			}
			return new SetIntersection(this, HashSet.fromObject(operand));
		}
		public function get empty():Boolean
		{
			return finestNodes.empty;
		}
		public function has(element:Object):Boolean
		{
			return false;
		}
		public function prSubsetOf(value:Object):Boolean
		{
			if (empty)
			{
				if (value is Set)
					return !Set(value).empty;
				for each (var x:* in value)
					return false;
				return true;
			}
			if (value is Taxon)
				return finestNodes.prSubsetOf(Taxon(value).finestNodes);
			return false;
		}
		public function subsetOf(value:Object):Boolean
		{
			if (empty)
				return true;
			if (value is Taxon)
				return finestNodes.subsetOf(Taxon(value).finestNodes);
			return false;
		}
		public function toString():String
		{
			if (empty)
				return "{}";
			if (finestNodes is FiniteSet)
				return FiniteSet(finestNodes).toVector().join(" ∪ ");
			return "Taxon:" + String(finestNodes);
		}
		public function toNodeSet():FiniteSet
		{
			return finestNodes as FiniteSet;
		}
		public function union(operand:Object):Set
		{
			if (operand is Taxon)
			{
				const result:Taxon = new Taxon();
				result.finestNodes = finestNodes.union(Taxon(operand).finestNodes);
				return result;
			}
			else if (operand is Set)
			{
				if (Set(operand).empty)
					return this;
				return new SetUnion(this, operand as Set);
			}
			return new SetUnion(this, HashSet.fromObject(operand));
		}
	}
}