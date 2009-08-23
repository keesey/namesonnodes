package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.domain.nodes.Node;

	public final class SuccessorIntersection extends AbstractOperation
	{
		internal var nodeGraph:NodeGraph;
		private const calcTable:CalcTable = new CalcTable();
		public function SuccessorIntersection(nodeGraph:NodeGraph)
		{
			super();
			assertNotNull(nodeGraph);
			this.nodeGraph = nodeGraph;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 1, 1))
				return getUnresolvableArgument(args);
			const s:FiniteSet = args[0] as FiniteSet;
			if (s.empty)
				return EmptySet.INSTANCE;
			if (s.size == 1)
				return nodeGraph.successors(s.singleMember as Node);
			const a:Array = [CalcTable.argumentsToToken(s.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r;
			var result:FiniteSet;
			for each (var x:Node in s)
			{
				if (result == null)
					result = HashSet.fromObject(nodeGraph.successors(x));
				else
				{
					result = result.intersect(nodeGraph.successors(x)) as FiniteSet;
					if (result.empty)
					{
						result = EmptySet.INSTANCE;
						break;
					}
				}
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "successor intersection";
		}
	}
}