package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;

	public final class NodeBasedClade extends AbstractOperation
	{
		private var nodeBasedCladogen:NodeBasedCladogen;
		private var successorUnion:SuccessorUnion;
		public function NodeBasedClade(successorUnion:SuccessorUnion,
			nodeBasedCladogen:NodeBasedCladogen)
		{
			super();
			assertNotNull(nodeBasedCladogen);
			assertNotNull(successorUnion);
			if (nodeBasedCladogen.datasetCollection != successorUnion.datasetCollection)
				throw new ArgumentError("Conflicting dataset collections.");
			this.nodeBasedCladogen = nodeBasedCladogen;
			this.successorUnion = successorUnion;
		}
		override public function apply(args:Array):Object
		{
			return successorUnion.apply([nodeBasedCladogen.apply(args)]);
		}
		public function toString():String
		{
			return "node-based clade";
		}
	}
}