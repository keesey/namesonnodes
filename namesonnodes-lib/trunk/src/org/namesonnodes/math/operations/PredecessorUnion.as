package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.Node;
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

	public final class PredecessorUnion extends AbstractOperation
	{
		internal var nodeGraph:NodeGraph;
		private const calcTable:CalcTable = new CalcTable();
		public function PredecessorUnion(nodeGraph:NodeGraph)
		{
			super();
			assertNotNull(nodeGraph);
			this.nodeGraph = nodeGraph;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, Set, 1, 1))
				return getUnresolvableArgument(args);
			const s:Set = toTaxon(args[0]);
			if (s.empty)
				return s;
			const nodes:Array = Taxon(s).toNodeSet().toArray();
			const a:Array = [CalcTable.argumentsToToken(nodes)];
			const r:* = calcTable.getResult(this, a);
			if (r is Set)
				return r;
			const resultNodes:MutableSet = new HashSet();
			for each (var x:Node in nodes)
				resultNodes.addMembers(nodeGraph.predecessors(x));
			const result:Set = nodesToTaxon(resultNodes);
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "predecessor union";
		}
	}
}