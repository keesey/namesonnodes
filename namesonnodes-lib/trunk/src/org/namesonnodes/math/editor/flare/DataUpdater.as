package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.namesonnodes.math.editor.elements.MathMLContainer;
	import org.namesonnodes.math.editor.elements.MathMLElement;

	public final class DataUpdater
	{
		private var data:Data;
		private const sprites:Dictionary = new Dictionary();
		private const elements:MutableSet = new HashSet();
		public function DataUpdater(data:Data, elements:Vector.<MathMLElement>, pos:Point)
		{
			super();
			this.data = data;
			readDataSprites();
			readElements(elements);
			removeUnusedSprites();
			addNewSprites(pos);
		}
		private function addNewSprites(pos:Point):void
		{
			for each (var element:MathMLElement in elements)
				findOrCreateSprite(element, pos);
		}
		private function findOrCreateSprite(element:MathMLElement, pos:Point):NodeSprite
		{
			const r:* = sprites[element];
			if (r is NodeSprite)
				return r as NodeSprite;
			const n:NodeSprite = data.addNode(element);
			n.x = pos.x;
			n.y = pos.y;
			n.renderer = new ElementRenderer(element);
			data.addNode(n);
			if (element.parent != null)
				data.addEdgeFor(n, findOrCreateSprite(element.parent, pos), true);
			return n;
		}
		private function readDataSprites():void
		{
			data.nodes.visit(function (n:NodeSprite):void
			{
				sprites[n.data] = n;
			});
		}
		private function readElements(elements:Vector.<MathMLElement>):void
		{
			for each (var element:MathMLElement in elements)
			{
				this.elements.add(element);
				if (element is MathMLContainer)
					readElements(MathMLContainer(element).toVector());
			}
		}
		private function removeUnusedSprites():void
		{
			for (var element:* in sprites)
			{
				if (!elements.has(element))
				{
					const n:NodeSprite = sprites[element] as NodeSprite;
					data.removeNode(n);
					var l:uint = n.inDegree;
					for (var i:uint = 0; i < l; ++i)
						data.removeEdge(n.getInEdge(i));
					l = n.outDegree;
					for (i = 0; i < l; ++i)
						data.removeEdge(n.getOutEdge(i));
					delete sprites[element];
				}
			}
		}
	}
}