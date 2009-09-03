package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.ArrowType;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.namesonnodes.math.editor.elements.MathMLContainer;
	import org.namesonnodes.math.editor.elements.MathMLElement;

	public final class DataUpdater
	{
		public static const EDGE_PROPERTIES:Object = {lineColor: 0xE0000000, lineWidth: 5,
				fillColor: 0xE0808080, arrowType: ArrowType.TRIANGLE,
				arrowHeight: 10, arrowWidth: 10, directed: true};
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
			data.edges.setProperties(EDGE_PROPERTIES);
		}
		private function addNewSprites(pos:Point):void
		{
			for each (var element:MathMLElement in elements)
				findOrCreateSprite(element, pos);
		}
		private static function elementDepth(element:MathMLElement):uint
		{
			if (element.parent == null)
				return 0;
			return elementDepth(element.parent) + 1;
		}
		private static function elementFilespace(element:MathMLContainer):int
		{
			const n:uint = element.numChildren;
			if (n == 0)
				return 1;
			var total:int = 0;
			for (var i:uint = 0; i < n; ++i)
			{
				const child:MathMLElement = element.getChildAt(i);
				if (child is MathMLContainer)
					total += elementFilespace(child as MathMLContainer);
				else
					total++;
			}
			return total;
		}
		private static function elementFile(element:MathMLElement):int
		{
			const parent:MathMLContainer = element.parent;
			if (parent == null)
				return 0;
			const offset:int = parent.getChildIndex(element) - (elementFilespace(parent) >> 1);
			return elementFile(parent) + offset;
		}
		private function findOrCreateSprite(element:MathMLElement, pos:Point):NodeSprite
		{
			const r:* = sprites[element];
			if (r is NodeSprite)
				return r as NodeSprite;
			const n:NodeSprite = data.addNode(element);
			sprites[element] = n;
			n.x = pos.x + elementFile(element) * 20;
			n.y = pos.y + (elementDepth(element) - 1) * 20;
			n.renderer = new ElementRenderer(element);
			const parent:MathMLContainer = element.parent;
			if (elements.has(parent))
			{
				const edge:EdgeSprite = 
					data.addEdgeFor(n, findOrCreateSprite(parent,
						new Point(pos.x, pos.y)), true);
				edge.data = {label: parent.getChildLabelAt(parent.getChildIndex(element))};
			}
			else
				trace("Not in elements: " + element.parent + " (parent of " + element + ")");
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
				}
			}
		}
	}
}