package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;

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
			if (!checkArguments(args, FiniteSet, 2, 2))
				return getUnresolvableArgument(args);
			const inSet:FiniteSet = args[0] as FiniteSet;
			const outSet:FiniteSet = args[1] as FiniteSet;
			if (inSet.empty)	
				return EmptySet.INSTANCE;
			const a:Array = [CalcTable.argumentsToToken(inSet.toArray()), CalcTable.argumentsToToken(outSet.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r as FiniteSet;
			var result:FiniteSet;
			const inPrc:FiniteSet = predecessorIntersection.apply([inSet]) as FiniteSet;
			if (inPrc.empty)
				result = EmptySet.INSTANCE;
			else
			{
				const outPrc:FiniteSet = predecessorUnion.apply([outSet]) as FiniteSet;
				result = successorUnion.apply([inPrc.diff(outPrc)]) as FiniteSet;
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