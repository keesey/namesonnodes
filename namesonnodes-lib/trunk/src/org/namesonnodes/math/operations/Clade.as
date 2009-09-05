package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.Collection;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	
	import org.namesonnodes.math.entities.Taxon;
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
			if (!checkArguments(args, Set, 1, 1))
				return getUnresolvableArgument(args) || UnresolvableTaxon.INSTANCE;
			const s:Set = toTaxon(args[0]);
			if (s.empty)
				return s;
			const nodes:Array = Taxon(s).toNodeSet().toArray();
			if (nodes.length == 1)
				return successorUnion.apply(args);
			const minimalSet:Set = minimal.apply(args) as Set;
			const minimalSize:uint = getNumNodes(minimalSet);
			if (nodes.length != minimalSize)
				return EmptySet.INSTANCE;
			if (Collection(successorIntersection.apply(args)).empty)
				return EmptySet.INSTANCE;
			return successorUnion.apply(args);
		}
		public function toString():String
		{
			return "clade";
		}
	}
}