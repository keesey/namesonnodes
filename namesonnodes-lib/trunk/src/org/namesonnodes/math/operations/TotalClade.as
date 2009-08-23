package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;

	public final class TotalClade extends AbstractOperation
	{
		private var calcTable:CalcTable = new CalcTable();
		private var branchBasedClade:BranchBasedClade;
		private var crownClade:CrownClade;
		public function TotalClade(branchBasedClade:BranchBasedClade, crownClade:CrownClade)
		{
			super();
			assertNotNull(branchBasedClade);
			assertNotNull(crownClade);
			if (branchBasedClade.nodeGraph != crownClade.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.branchBasedClade = branchBasedClade;
			this.crownClade = crownClade;
		}
		internal function get nodeGraph():NodeGraph
		{
			return branchBasedClade.nodeGraph;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 2, 2))
				return getUnresolvableArgument(args);
			const specifiers:FiniteSet = args[0] as FiniteSet;
			const extant:FiniteSet = args[1] as FiniteSet;
			const a:Array = [CalcTable.argumentsToToken(specifiers.toArray()),
				CalcTable.argumentsToToken(extant.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r as FiniteSet;
			const crown:FiniteSet = crownClade.apply(args) as FiniteSet;
			var result:FiniteSet;
			if (crown.empty)
				result = EmptySet.INSTANCE;
			else
			{
				const out:FiniteSet = extant.diff(crown) as FiniteSet;
				result = branchBasedClade.apply([crown, out]) as FiniteSet;
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String 
		{
			return "total group";
		}
	}
}