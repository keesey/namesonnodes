package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.domain.nodes.Node;

	public final class Minimal extends AbstractOperation
	{
		internal var nodeGraph:NodeGraph;
		private const calcTable:CalcTable = new CalcTable();
		public function Minimal(nodeGraph:NodeGraph)
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
				return s;
			const a:Array = [CalcTable.argumentsToToken(s.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r;
			const result:MutableSet = HashSet.fromObject(s);
			for each (var x:Node in s)
				if (result.has(x))
					for each (var y:Node in s)
						if (nodeGraph.succeeds(x, y))
						{
							result.remove(x);
							break;
						}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "minimal";
		}
	}
}