package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;

	public final class ApomorphyBasedClade extends AbstractOperation
	{
		private var successorUnion:SuccessorUnion;
		private var synapomorphicPredecessors:SynapomorphicPredecessors;
		public function ApomorphyBasedClade(successorUnion:SuccessorUnion,
			synapomorphicPredecessors:SynapomorphicPredecessors)
		{
			super();
			assertNotNull(successorUnion);
			assertNotNull(synapomorphicPredecessors);
			if (successorUnion.datasetCollection != synapomorphicPredecessors.datasetCollection)
				throw new ArgumentError("Conflicting dataset collections.");
			this.successorUnion = successorUnion;
			this.synapomorphicPredecessors = synapomorphicPredecessors;
		}
		override public function apply(args:Array) : Object
		{
			return successorUnion.apply([synapomorphicPredecessors.apply(args)]);
		}
		public function toString():String
		{
			return "apomorphy-based clade";
		}
	}
}