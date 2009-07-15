package org.namesonnodes.flare
{
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.phylo.Phylogeny;

	public final class DataPhylogenyFactory
	{
		private const vertexNodeMap:Dictionary = new Dictionary();
		public function DataPhylogenyFactory()
		{
			super();
		}
		public function createData(phylogeny:Phylogeny):Data
		{
			const data:Data = new Data();
			data.directedEdges = true;
			for each (var vertex:Object in phylogeny.heredityGraph.vertices)
				vertexNodeMap[vertex] = data.addNode(vertex);
			for each (var arc:FiniteList in phylogeny.heredityWeightedGraph.edges)
			{
				var head:NodeSprite = vertexNodeMap[arc.getMember(0)] as NodeSprite;
				var tail:NodeSprite = vertexNodeMap[arc.getMember(1)] as NodeSprite;
				data.addEdgeFor(head, tail, true, arc);
			}
			const minimals:FiniteSet = phylogeny.heredityGraph.minimal(phylogeny.heredityGraph.vertices);
			const minimalNodes:MutableSet = new HashSet();
			for each (var minimal:Object in minimals)
				minimalNodes.add(vertexNodeMap[minimal]);
			if (!minimalNodes.empty)
			{
				if (minimalNodes.size == 1)
					data.root = minimalNodes.singleMember as NodeSprite;
				else
				{
					const root:NodeSprite = new NodeSprite();
					data.addNode(root);
					for each (var minimalNode:NodeSprite in minimalNodes)
						data.addEdgeFor(root, minimalNode, true);
					data.root = root;
				}
			}
			return data;
		}
	}
}