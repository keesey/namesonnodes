package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

	public final class CrownClade extends AbstractOperation
	{
		private var calcTable:CalcTable = new CalcTable();
		private var nodeBasedClade:NodeBasedClade;
		public function CrownClade(nodeBasedClade:NodeBasedClade)
		{
			super();
			assertNotNull(nodeBasedClade);
			this.nodeBasedClade = nodeBasedClade;
		}
		internal function get nodeGraph():NodeGraph
		{
			return nodeBasedClade.nodeGraph;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, Set, 2, 2))
				return getUnresolvableArgument(args);
			const specifiers:Set = toTaxon(args[0]);
			if (specifiers.empty)
				return specifiers;
			const extant:Set = toTaxon(args[1]);
			if (extant.empty)
				return extant;
			const a:Array = [CalcTable.argumentsToToken(Taxon(specifiers).toNodeSet().toArray()),
				CalcTable.argumentsToToken(Taxon(extant).toNodeSet().toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is Set)
				return r;
			const result:Set = nodeBasedClade.apply([specifiers.intersect(extant)]) as Set;
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String 
		{
			return "crown group"
		}
	}
}