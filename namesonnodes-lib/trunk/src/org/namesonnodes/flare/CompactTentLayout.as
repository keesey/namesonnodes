package org.namesonnodes.flare
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.relate.Order;
	
	import flare.vis.data.DataSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.operator.layout.Layout;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public final class CompactTentLayout extends Layout
	{
		private var collapsed:MutableSet;
		private var plots:Dictionary;
		private var distances:Dictionary;
		private var leaves:FiniteSet = EmptySet.INSTANCE;
		private var nonLeaves:MutableSet;
		private var xSpacing:uint;
		private var ySpacing:uint;
		private var bottomLeaf:NodeSprite;
		private var topLeaf:NodeSprite;
		private var maxDistance:uint;
		private var left:Number;
		private var predecessorTable:Dictionary;
		private var prcDistanceTable:Dictionary;
		public function CompactTentLayout(xSpacing:uint = 10, ySpacing:uint = 10)
		{
			super();
			this.xSpacing = xSpacing;
			this.ySpacing = ySpacing;
		}
		override public function get layoutRoot() : DataSprite
		{
			var root:DataSprite;
			try
			{
				root = super.layoutRoot;	
			}
			catch (e:Error)
			{
				trace("[WARNING]", e.name + ": " + e.message);
			}
			if (root == null && visualization != null && visualization.data != null)
				root = visualization.data.root;
			return root;
		}
		override public function set layoutRoot(r:DataSprite) : void
		{
			if (layoutRoot != r)
			{
				super.layoutRoot = r;
				plots = null;
				distances = null;
				leaves = null;
				nonLeaves = null;
				topLeaf = bottomLeaf = null;
				predecessorTable = null;
				prcDistanceTable = null;
				collapsed = null;
			}
		}
		private function collapseNode(node:NodeSprite):void
		{
			if (collapsed.has(node))
				return;
			collapsed.add(node);
			var i:uint;
			const inDegree:uint = node.inDegree;
			if (inDegree != 0)
			{
				const p:Point = plots[node] as Point;
				for (i = 0; i < inDegree; ++i)
				{
					var prcNode:NodeSprite = node.getInNode(i);
					collapseNode(prcNode);
					var prcNodeRight:Number = Point(plots[prcNode]).x + prcNode.width / 2;
					p.x = (i == 0) ? prcNodeRight : Math.max(p.x, prcNodeRight);
				}
				p.x += xSpacing + node.width / 2;
			}
			const outDegree:uint = node.outDegree;
			for (i = 0; i < outDegree; ++i)
				collapseNode(node.getOutNode(i));	
		}
		private function findLeaves(ns:NodeSprite):FiniteSet
		{
			if (ns == null)
				return EmptySet.INSTANCE;
			const outDegree:uint = ns.outDegree;
			if (outDegree == 0)
				return HashSet.createSingleton(ns);
			nonLeaves.add(ns);
			var leaves:FiniteSet = EmptySet.INSTANCE;
			for (var i:uint = 0; i < outDegree; ++i)
				leaves = leaves.union(findLeaves(ns.getOutNode(i))) as FiniteSet;
			return leaves;
		}
		private function findPoles():Vector.<NodeSprite>
		{
			maxDistance = 0;
			const poles:Vector.<NodeSprite> = new Vector.<NodeSprite>(2);
			const leaves:Vector.<Object> = this.leaves.toVector();
			const n:uint = leaves.length;
			for (var i:uint = 0; i < n - 1; ++i)
			{
				var leafA:NodeSprite = leaves[i] as NodeSprite;
				for (var j:uint = i + 1; j < n; ++j)
				{
					var leafB:NodeSprite = leaves[j] as NodeSprite;
					var distance:uint = leafDistance(leafA, leafB); 
					if (distance > maxDistance)
					{
						poles[0] = leafA;
						poles[1] = leafB;
						maxDistance = distance;
					}
				}
			}
			return poles.sort(Order.findOrder);
		}
		override protected function layout() : void
		{
			if (distances == null)
			{
				distances = new Dictionary();
				plots = new Dictionary();
				predecessorTable = new Dictionary();
				prcDistanceTable = new Dictionary();
				nonLeaves = new HashSet();
				collapsed = new HashSet();
				if (layoutRoot != null)
				{
					leaves = findLeaves(layoutRoot as NodeSprite);
					if (leaves.size < 2)
						plotNoPoles();
					else
					{
						const poles:Vector.<NodeSprite> = findPoles();
						plotPoles(poles[0] as NodeSprite, poles[1] as NodeSprite);
					}
					left = 0;
					plotTent(layoutRoot as NodeSprite);
					collapseNode(layoutRoot as NodeSprite);
					// :TODO: minimizeOverlap();
				}
			}
			for (var n:* in plots)
			{
				var p:Point = plots[n] as Point;
				var o:Object = _t.$(n);
				o.x = p.x - left + xSpacing;
				o.y = p.y;
			}
		}
		/*
		private function adjacentNodes(ns:NodeSprite):FiniteSet
		{
			const adjacent:MutableSet = new HashSet();
			var n:uint = ns.outDegree;
			for (var i:uint = 0; i < n; ++i)
				adjacent.add(ns.getOutNode(i));
			n = ns.inDegree;
			for (i = 0; i < n; ++i)
				adjacent.add(ns.getInNode(i));
			return adjacent;
		*/
		private function predecessors(ns:NodeSprite):FiniteSet
		{
			const r:* = predecessorTable[ns];
			if (r is FiniteSet)
				return r as FiniteSet;
			var s:FiniteSet = HashSet.createSingleton(ns);
			const n:uint = ns.inDegree;
			for (var i:uint = 0; i < n; ++i)
				s = s.union(predecessors(ns.getInNode(i)))as FiniteSet;
			predecessorTable[ns] = s;
			return s;
		}
		private function prcDistance(prc:NodeSprite, suc:NodeSprite):int
		{
			var t:* = prcDistanceTable[prc];
			if (t is Dictionary)
			{
				const r:* = t[suc];
				if (r is int)
					return r as int;
			}
			else
				t = prcDistanceTable[prc] = new Dictionary();
			if (prc == suc)
				return 0;
			const n:int = suc.inDegree;
			var d:int = int.MAX_VALUE;
			for (var i:uint = 0; i < n; ++i)
			{
				var prc2:NodeSprite = suc.getInNode(i);
				d = Math.min(d, prcDistance(prc, prc2) + 1);
				if (d == 0)
					break;
			}
			t[suc] = d;
			return d;
		}
		private function leafDistance(n1:NodeSprite, n2:NodeSprite):int
		{
			if (n1 == n2)
				return 0;
			var t1:* = distances[n1];
			if (t1 is Dictionary)
			{
				const r:* = t1[n2];
				if (r is int)
					return r as int;
			}
			else
				t1 = distances[n1] = new Dictionary(); 
			var t2:* = distances[n2];
			if (!(t2 is Dictionary))
				t2 = distances[n2] = new Dictionary();
			const commonPredecessors:FiniteSet = predecessors(n1).intersect(predecessors(n2)) as FiniteSet;
			var d:int = int.MAX_VALUE;
			for each (var prc:NodeSprite in commonPredecessors)
			{
				d = Math.min(d, prcDistance(prc, n1) + prcDistance(prc, n2));
				if (d == 0)
					break;
			}
			t1[n2] = d;
			t2[n1] = d;
			return d;
		}
		private function plotNoPoles():void
		{
			if (leaves.size == 1)
			{
				var leaf:NodeSprite = leaves.singleMember as NodeSprite;
				leaf.x = leaf.y = 0;
				plots[leaf] = new Point(0, 0);
			}
		}
		private function get leavesHeight():uint
		{
			var h:uint = 0;
			for each (var leaf:NodeSprite in leaves)
				h += leaf.height;
			return h + (leaves.size - 1) * ySpacing;
		}
		private function leafOrder(ns:NodeSprite):Number
		{
			if (ns == topLeaf)
				return 0;
			if (ns == bottomLeaf)
				return 1;
			return (leafDistance(topLeaf, ns) + maxDistance - leafDistance(bottomLeaf, ns))
				/ (2 * maxDistance);
		}
		private function leafSort(a:NodeSprite, b:NodeSprite):int
		{
			const orderA:Number = leafOrder(a);
			const orderB:Number = leafOrder(b);
			if (isNaN(orderA) || isNaN(orderB))
				return 0;
			const diff:Number = orderB - orderA;
			if (diff == 0)
				return 0;
			if (diff < 0)
				return -1;
			return 1;
		}
		private function plotTent(root:NodeSprite):Point
		{
			const r:* = plots[root];
			if (r is Point)
				return r as Point;
			const p:Point = new Point();
			const w:Number = root.width / 2 + xSpacing;
			const n:uint = root.outDegree;
			var top:Number = Number.MAX_VALUE;
			var bottom:Number = Number.MIN_VALUE;
			for (var i:uint = 0; i < n; ++i)
			{
				var child:NodeSprite = root.getOutNode(i);
				var p2:Point = plotTent(child);
				var h:Number = child.height / 2;
				p.x = Math.min(p.x, p2.x - w - child.width / 2);
				top = Math.min(top, p2.y - h);
				bottom = Math.max(bottom, p2.y + h);
			}
			p.y = (top + bottom) / 2;
			left = Math.min(left, p.x);
			plots[root] = p;
			return p;
		}
		private function plotPoles(topPole:NodeSprite, bottomPole:NodeSprite):void
		{
			topLeaf = topPole;
			bottomLeaf = bottomPole;
			const height:uint = leavesHeight;
			const leaves:Vector.<Object> = this.leaves.toVector().sort(leafSort);
			const n:uint = leaves.length;
			var y:Number = ySpacing;
			for (var i:uint = 0; i < n; ++i)
			{
				var leaf:NodeSprite = leaves[i] as NodeSprite;
				var p:Point = new Point(-leaf.width / 2, y);
				y += leaf.height + ySpacing;
				left = Math.min(p.x, left);
				plots[leaf] = p;
			}
		}
	}
}