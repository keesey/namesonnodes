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
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;

	public final class SynapomorphicPredecessors extends AbstractOperation
	{
		private var predecessorIntersection:PredecessorIntersection;
		private const calcTable:CalcTable = new CalcTable();
		public function SynapomorphicPredecessors(predecessorIntersection:PredecessorIntersection)
		{
			super();
			assertNotNull(predecessorIntersection);
			this.predecessorIntersection = predecessorIntersection;
		}
		internal function get datasetCollection():DatasetCollection
		{
			return predecessorIntersection.datasetCollection;
		}
		private function isCommonSynapomorphicPredecessor(prc:Node,
			representative:FiniteSet, apomorphic:FiniteSet):Boolean
		{
			for each (var rep:Node in representative)
				if (!isSynapomorphicPredecessor(prc, rep, apomorphic))
					return false;
			return true;
		}
		private function isSynapomorphicPredecessor(prc:Node, suc:Node,
			apomorphic:FiniteSet):Boolean
		{
			const paths:FiniteSet = predecessorIntersection
				.datasetCollection.paths(prc, suc);
			if (paths.empty)
				return false;
			for each (var path:FiniteList in paths)
				if (path.every(apomorphic.has, apomorphic))
					return true;
			return false;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 2, 2))
				return getUnresolvableArgument(args);
			const apomorphic:FiniteSet = args[0] as FiniteSet;
			const representative:FiniteSet = args[1] as FiniteSet;
			if (apomorphic.empty || representative.empty)
				return EmptySet.INSTANCE;
			const a:Array = [CalcTable.argumentsToToken(apomorphic.toArray()),
				CalcTable.argumentsToToken(representative.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r as FiniteSet;
			var result:FiniteSet;
			if (!representative.subsetOf(apomorphic))
				result = EmptySet.INSTANCE;
			else
			{
				const apomorphicPredecessors:FiniteSet = Set(predecessorIntersection.apply([representative])).intersect(apomorphic) as FiniteSet;
				if (apomorphicPredecessors.empty)
					result = EmptySet.INSTANCE
				else
				{
					result = new HashSet();
					for each (var prc:Node in apomorphicPredecessors)
						if (isCommonSynapomorphicPredecessor(prc, representative, apomorphic))
							MutableCollection(result).add(prc);
					if (result.empty)
						result = EmptySet.INSTANCE;
				}
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "synapomorphic predecessors";
		}
	}
}