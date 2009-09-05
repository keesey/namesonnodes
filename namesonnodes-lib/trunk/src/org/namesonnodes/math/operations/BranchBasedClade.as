package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

	public final class BranchBasedClade extends AbstractOperation
	{
		private const calcTable:CalcTable = new CalcTable();
		private var predecessorIntersection:PredecessorIntersection;
		private var predecessorUnion:PredecessorUnion;
		private var successorUnion:SuccessorUnion;
		public function BranchBasedClade(successorUnion:SuccessorUnion, predecessorUnion:PredecessorUnion, predecessorIntersection:PredecessorIntersection)
		{
			super();
			assertNotNull(successorUnion);
			assertNotNull(predecessorUnion);
			assertNotNull(predecessorIntersection);
			if (successorUnion.nodeGraph != predecessorUnion.nodeGraph || predecessorUnion.nodeGraph != predecessorIntersection.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.successorUnion = successorUnion;
			this.predecessorUnion = predecessorUnion;
			this.predecessorIntersection = predecessorIntersection;
		}
		internal function get nodeGraph():NodeGraph
		{
			return successorUnion.nodeGraph;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, Set, 2, 2))
				return getUnresolvableArgument(args);
			const inSet:Set = toTaxon(args[0]);
			if (inSet.empty)	
				return inSet;
			const outSet:Set = toTaxon(args[1]);
			const inNodes:Array = Taxon(inSet).toNodeSet().toArray();
			const outNodes:Array = toNodeArray(outSet);
			const a:Array = [CalcTable.argumentsToToken(inNodes), CalcTable.argumentsToToken(outNodes)];
			const r:* = calcTable.getResult(this, a);
			if (r is Set)
				return r;
			var result:Set;
			const inPrc:Set = predecessorIntersection.apply([inSet]) as Set;
			if (inPrc.empty)
				result = EmptySet.INSTANCE;
			else
			{
				const outPrc:Set = predecessorUnion.apply([outSet]) as Set;
				result = successorUnion.apply([inPrc.diff(outPrc)]) as Set;
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString() : String
		{
			return "branch-based clade";
		}
	}
}