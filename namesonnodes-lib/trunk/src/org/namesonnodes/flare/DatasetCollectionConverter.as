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
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;

	public final class DatasetCollectionConverter
	{
		private var _datasetCollection:DatasetCollection;
		private var _data:Data;
		public function DatasetCollectionConverter(datasetCollection:DatasetCollection)
		{
			super();
			_datasetCollection = datasetCollection;
		}
		public function get data():Data
		{
			if (_data == null)
			{
				_data = new Data(true);
				var node:Node;
				var nodeSprite:NodeSprite;
				const nodeSprites:Dictionary = new Dictionary();
				for each (node in _datasetCollection.universalTaxon)
				{
					nodeSprite = new NodeSprite();
					nodeSprite.data = node;
					nodeSprites[node] = nodeSprite;
					_data.addNode(nodeSprite);
				}
				const roots:MutableSet = new HashSet();
				var edgeSprite:EdgeSprite;
				for each (node in _datasetCollection.universalTaxon)
				{
					nodeSprite = nodeSprites[node] as NodeSprite;
					var prcNodes:FiniteSet = datasetCollection.immediatePredecessors(node);
					if (prcNodes.empty)
						roots.add(nodeSprite);
					else
						for each (var prcNode:Node in prcNodes)
						{
							var prcNodeSprite:NodeSprite = nodeSprites[prcNode] as NodeSprite;
							var weight:int = Math.max(1, _datasetCollection.generationDistance(node, prcNode));
							edgeSprite = new EdgeSprite(prcNodeSprite, nodeSprite, true);
							edgeSprite.arrowType = ArrowType.TRIANGLE;
							edgeSprite.arrowHeight = 5;
							edgeSprite.arrowWidth = 5;
							edgeSprite.data = weight;
							_data.addEdge(edgeSprite);
							//edgeSprite.render();
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
		public function get datasetCollection():DatasetCollection
		{
			return _datasetCollection;
		}
	}
}