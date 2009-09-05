package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

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
			if (!checkArguments(args, Set, 2, 2))
				return getUnresolvableArgument(args);
			const specifiers:Set = toTaxon(args[0]);
			if (specifiers.empty)
				return EmptySet.INSTANCE;
			const extant:Set = toTaxon(args[1]);
			if (extant.empty)
				return EmptySet.INSTANCE;
			const a:Array = [CalcTable.argumentsToToken(Taxon(specifiers).toNodeSet().toArray()),
				CalcTable.argumentsToToken(Taxon(extant).toNodeSet().toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is Set)
				return r;
			const crown:Set = crownClade.apply(args) as Set;
			var result:Set;
			if (crown.empty)
				result = EmptySet.INSTANCE;
			else
			{
				const out:Set = extant.diff(crown);
				result = branchBasedClade.apply([crown, out]) as Set;
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