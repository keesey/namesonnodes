package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.math.entities.Taxon;

	public final class BranchBasedCladogen extends AbstractOperation
	{
		private const calcTable:CalcTable = new CalcTable();
		private var minimal:Minimal;
		private var predecessorIntersection:PredecessorIntersection;
		private var predecessorUnion:PredecessorUnion;
		public function BranchBasedCladogen(minimal:Minimal, predecessorUnion:PredecessorUnion, predecessorIntersection:PredecessorIntersection)
		{
			super();
			assertNotNull(minimal);
			assertNotNull(predecessorUnion);
			assertNotNull(predecessorIntersection);
			if (minimal.nodeGraph != predecessorUnion.nodeGraph || predecessorUnion.nodeGraph != predecessorIntersection.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.minimal = minimal;
			this.predecessorUnion = predecessorUnion;
			this.predecessorIntersection = predecessorIntersection;
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
				result = minimal.apply([inPrc.diff(outPrc)]) as Set;
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString() : String
		{
			return "branch-based cladogen";
		}
	}
}