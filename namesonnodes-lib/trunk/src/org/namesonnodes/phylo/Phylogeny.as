package org.namesonnodes.phylo
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.graphs.AcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.HashNetwork;
	import a3lbmonkeybrain.calculia.collections.graphs.MutableAcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.WeightedGraph;

	public final class Phylogeny
	{
		internal const _heredityGraph:HashNetwork = new HashNetwork();
		internal const _inclusionGraph:MutableAcyclicGraph = new HashNetwork();
		internal var coarsestSet:FiniteSet;
		internal var finestSet:FiniteSet;
		public function Phylogeny()
		{
			super();
		}
		public function get heredityGraph():AcyclicGraph
		{
			return _heredityGraph;
		}
		public function get heredityWeightedGraph():WeightedGraph
		{
			return _heredityGraph;
		}
		public function get inclusionGraph():AcyclicGraph
		{
			return _inclusionGraph;
		}
		public function coarsest(v:FiniteSet):FiniteSet
		{
			if (coarsestSet == null)
				updateCoarsest();
			return _inclusionGraph.allPredecessors(v).intersect(coarsestSet) as FiniteSet;
		}
		public function finest(v:FiniteSet):FiniteSet
		{
			if (finestSet == null)
				updateFinest();
			return _inclusionGraph.allSuccessors(v).intersect(finestSet) as FiniteSet;
		}
		internal function updateCoarsest():void
		{
			const coarsestIncluded:FiniteSet = _inclusionGraph.minimal(_inclusionGraph.vertices);
			coarsestSet = coarsestIncluded.union(_heredityGraph.vertices.diff(_inclusionGraph.vertices)) as FiniteSet;
		}
		internal function updateFinest():void
		{
			const finestIncluded:FiniteSet = _inclusionGraph.maximal(_inclusionGraph.vertices);
			finestSet = finestIncluded.union(_heredityGraph.vertices.diff(_inclusionGraph.vertices)) as FiniteSet;
		}
	}
}