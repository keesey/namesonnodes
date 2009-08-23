package org.namesonnodes.flare
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.ArrowType;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.nodes.Node;
	import org.namesonnodes.domain.nodes.NodeGraph;
	
	public final class NodeGraphDataConverter
	{
		private var _nodeGraph:NodeGraph;
		private var _data:Data;
		public function NodeGraphDataConverter(nodeGraph:NodeGraph)
		{
			super();
			_nodeGraph = nodeGraph;
		}
		public function get data():Data
		{
			if (_data == null)
			{
				_data = new Data(true);
				var node:Node;
				var nodeSprite:NodeSprite;
				const nodeSprites:Dictionary = new Dictionary();
				for each (node in _nodeGraph.universalTaxon)
				{
					nodeSprite = new NodeSprite();
					nodeSprite.data = node;
					nodeSprites[node] = nodeSprite;
					_data.addNode(nodeSprite);
				}
				const roots:MutableSet = new HashSet();
				var edgeSprite:EdgeSprite;
				for each (node in _nodeGraph.universalTaxon)
				{
					nodeSprite = nodeSprites[node] as NodeSprite;
					var prcNodes:FiniteSet = nodeGraph.immediatePredecessors(node);
					if (prcNodes.empty)
						roots.add(nodeSprite);
					else
						for each (var prcNode:Node in prcNodes)
						{
							var prcNodeSprite:NodeSprite = nodeSprites[prcNode] as NodeSprite;
							var weight:int = Math.max(1, _nodeGraph.generationDistance(node, prcNode));
							edgeSprite = _data.addEdgeFor(prcNodeSprite, nodeSprite, true, {weight: weight});
							edgeSprite.arrowType = ArrowType.TRIANGLE;
							edgeSprite.arrowHeight = 5;
							edgeSprite.arrowWidth = 5;
						}
				}
				if (roots.size == 1)
					_data.root = roots.singleMember as NodeSprite;
				else if (!roots.empty)
				{
					const root:NodeSprite = new NodeSprite();
					root.visible = false;
					_data.addNode(root);
					for each (var subroot:NodeSprite in roots)
					{
						edgeSprite = _data.addEdgeFor(root, subroot);
						edgeSprite.visible = false;
					}
					_data.root = root;
				}
			}
			return _data;
		}
		public function get nodeGraph():NodeGraph
		{
			return _nodeGraph;
		}
	}
}