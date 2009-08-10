package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;

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
			if (maximal.datasetCollection != predecessorIntersection.datasetCollection)
				throw new ArgumentError("Conflicting dataset collections.");
			this.maximal = maximal;
			this.predecessorIntersection = predecessorIntersection;
		}
		override public function apply(args:Array):Object
		{
			if (!checkArguments(args, FiniteSet, 1))
				throw new MathMLError("Invalid arguments for 'Node-Based Cladogen' operation.");
			const s:FiniteSet = args[0] as FiniteSet;
			if (s.empty)
				return EmptySet.INSTANCE;
			return maximal.apply([predecessorIntersection.apply([s])]);
		}
	}
}