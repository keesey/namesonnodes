package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableCollection;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.Node;
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

	public final class SynapomorphicPredecessors extends AbstractOperation
	{
		private var prcIntersect:PredecessorIntersection;
		private const calcTable:CalcTable = new CalcTable();
		public function SynapomorphicPredecessors(prcIntersect:PredecessorIntersection)
		{
			super();
			assertNotNull(prcIntersect);
			this.prcIntersect = prcIntersect;
		}
		internal function get nodeGraph():NodeGraph
		{
			return prcIntersect.nodeGraph;
		}
		private function isCommonSynapomorphicPredecessor(prc:Node,
			representative:Set, apomorphic:Set):Boolean
		{
			for each (var rep:Node in representative)
				if (!isSynapomorphicPredecessor(prc, rep, apomorphic))
					return false;
			return true;
		}
		private function isSynapomorphicPredecessor(prc:Node, suc:Node,
			apomorphic:Set):Boolean
		{
			const paths:Set = prcIntersect.nodeGraph.paths(prc, suc);
			if (paths.empty)
				return false;
			for each (var path:FiniteList in paths)
				if (pathInSet(path, apomorphic))
					return true;
			return false;
		}
		private static function pathInSet(path:FiniteList, s:Set):Boolean
		{
			for each (var x:Object in path)
				if (!s.has(x))
					return false;
			return true;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, Set, 2, 2))
				return getUnresolvableArgument(args);
			const apomorphic:Set = toTaxon(args[0]);
			if (apomorphic.empty)
				return apomorphic;
			const representative:Set = toTaxon(args[1]);
			if (representative.empty)
				return representative;
			const apomorphicNodeSet:FiniteSet = Taxon(apomorphic).toNodeSet();
			const representativeNodeSet:FiniteSet = Taxon(representative).toNodeSet();
			const apomorphicNodes:Array = apomorphicNodeSet.toArray();
			const representativeNodes:Array = representativeNodeSet.toArray();
			const a:Array = [CalcTable.argumentsToToken(apomorphicNodes),
				CalcTable.argumentsToToken(representativeNodes)];
			const r:* = calcTable.getResult(this, a);
			if (r is Set)
				return r;
			var resultNodes:FiniteSet;
			if (!representativeNodeSet.subsetOf(apomorphicNodeSet))
				resultNodes = EmptySet.INSTANCE;
			else
			{
				const commonPrc:Set = prcIntersect.apply([representative]) as Set;
				if (commonPrc.empty)
					resultNodes = EmptySet.INSTANCE;
				else
				{
					const apomorphicPrcNodeSet:FiniteSet = toNodeSet(commonPrc).intersect(apomorphicNodeSet) as FiniteSet;
					if (apomorphicPrcNodeSet.empty)
						resultNodes = EmptySet.INSTANCE;
					else
					{
						resultNodes = new HashSet();
						for each (var prc:Node in apomorphicPrcNodeSet)
							if (isCommonSynapomorphicPredecessor(prc, representativeNodeSet, apomorphicNodeSet))
								MutableCollection(resultNodes).add(prc);
					}
				}
			}
			const result:Set = nodesToTaxon(resultNodes);
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "synapomorphic predecessors";
		}
	}
}