package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.Collection;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteCollection;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	
	import org.namesonnodes.math.resolve.UnresolvableTaxon;

	public final class Clade extends AbstractOperation
	{
		private var minimal:Minimal;
		private var successorIntersection:SuccessorIntersection;
		private var successorUnion:SuccessorUnion;
		public function Clade(minimal:Minimal, successorUnion:SuccessorUnion, successorIntersection:SuccessorIntersection)
		{
			super();
			assertNotNull(minimal);
			assertNotNull(successorUnion);
			assertNotNull(successorIntersection);
			if (minimal.nodeGraph != successorUnion.nodeGraph || successorUnion.nodeGraph != successorIntersection.nodeGraph)
				throw new ArgumentError("Conflicting node graphs.");
			this.minimal = minimal;
			this.successorUnion = successorUnion;
			this.successorIntersection = successorIntersection;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 1, 1))
				return getUnresolvableArgument(args) || UnresolvableTaxon.INSTANCE;
			const s:FiniteSet = args[0] as FiniteSet;
			if (s.empty)
				return EmptySet.INSTANCE;
			if (s.size == 1)
				return successorUnion.apply([s]);
			if (s.size != FiniteCollection(minimal.apply([s])).size)
				return EmptySet.INSTANCE;
			if (Collection(successorIntersection.apply([s])).empty)
				return EmptySet.INSTANCE;
			return successorUnion.apply([s]);
		}
		public function toString():String
		{
			return "clade";
		}
	}
}