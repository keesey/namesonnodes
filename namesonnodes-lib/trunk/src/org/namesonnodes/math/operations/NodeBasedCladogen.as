package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	
	import org.namesonnodes.domain.nodes.NodeGraph;

	public final class NodeBasedCladogen extends AbstractOperation
	{
		private var maximal:Maximal;
		private var predecessorIntersection:PredecessorIntersection;
		public function NodeBasedCladogen(maximal:Maximal,
			predecessorIntersection:PredecessorIntersection)
		{
			super();
			assertNotNull(maximal);
			assertNotNull(predecessorIntersection);
			if (maximal.nodeGraph != predecessorIntersection.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.maximal = maximal;
			this.predecessorIntersection = predecessorIntersection;
		}
		internal function get nodeGraph():NodeGraph
		{
			return maximal.nodeGraph;
		}
		override public function apply(args:Array):Object
		{
			if (!checkArguments(args, FiniteSet, 1))
				return getUnresolvableArgument(args);
			var s:FiniteSet = args[0] as FiniteSet;
			const l:uint = args.length;
			if (l != 1)	
				for (var i:uint = 1; i < l; ++i)
					s = s.union(args[i]) as FiniteSet;
			if (s.empty)
				return EmptySet.INSTANCE;
			return maximal.apply([predecessorIntersection.apply([s])]);
		}
		public function toString():String
		{
			return "node-based cladogen";
		}
	}
}