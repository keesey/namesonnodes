package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;

	public final class ApomorphyBasedCladogen extends AbstractOperation
	{
		private var minimal:Minimal;
		private var synapomorphicPredecessors:SynapomorphicPredecessors;
		public function ApomorphyBasedCladogen(minimal:Minimal,
			synapomorphicPredecessors:SynapomorphicPredecessors)
		{
			super();
			assertNotNull(minimal);
			assertNotNull(synapomorphicPredecessors);
			if (minimal.nodeGraph != synapomorphicPredecessors.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.minimal = minimal;
			this.synapomorphicPredecessors = synapomorphicPredecessors;
		}
		override public function apply(args:Array) : Object
		{
			return minimal.apply([synapomorphicPredecessors.apply(args)]);
		}
		public function toString():String
		{
			return "apomorphy-based cladogen";
		}
	}
}