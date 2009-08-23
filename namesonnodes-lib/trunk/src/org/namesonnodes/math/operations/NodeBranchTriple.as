package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.VectorList;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;

	public final class NodeBranchTriple extends AbstractOperation
	{
		private var branchBasedClade:BranchBasedClade;
		private var nodeBasedClade:NodeBasedClade;
		public function NodeBranchTriple(nodeBasedClade:NodeBasedClade, branchBasedClade:BranchBasedClade)
		{
			super();
			assertNotNull(nodeBasedClade);
			assertNotNull(branchBasedClade);
			if (nodeBasedClade.nodeGraph != branchBasedClade.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.branchBasedClade = branchBasedClade;
			this.nodeBasedClade = nodeBasedClade;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 2, 2))
				return getUnresolvableArgument(args);
			//return VectorList.fromObject([nodeBasedClade.apply(args),
			//	branchBasedClade.apply(args),
			//	branchBasedClade.apply([args[1], args[0]])]);
			// :TODO: Revert after fixing calculia
			return [nodeBasedClade.apply(args),
				branchBasedClade.apply(args),
				branchBasedClade.apply([args[1], args[0]])];
		}
		public function toString():String
		{
			return "node-branch triple";
		}
	}
}