package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.filter.filterType;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLResolver;
	
	import flare.animate.TransitionEvent;
	import flare.animate.Transitioner;
	import flare.display.TextSprite;
	import flare.flex.FlareVis;
	import flare.vis.controls.ClickControl;
	import flare.vis.controls.TooltipControl;
	import flare.vis.data.Data;
	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.events.SelectionEvent;
	import flare.vis.events.TooltipEvent;
	import flare.vis.events.VisualizationEvent;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.layout.ForceDirectedLayout;
	
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	
	import org.namesonnodes.math.editor.drag.ElementDragEvent;
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathElement;
	import org.namesonnodes.math.editor.elements.MathMLContainer;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.elements.MissingElement;

	public final class MathVis extends FlareVis
	{
		private static const EDGE_MARK_FILTERS:Array = [new GlowFilter(0xFFFFFF, 1.0, 4, 4, 3, 3)];
		public static const TRANSITION_SECONDS:Number = 3;
		private static const NODE_FILTER:Function = filterType(NodeSprite);
		private static const markedSprites:MutableSet = new HashSet();
		private var dataInvalid:Boolean = false;
		private var transitioner:Transitioner;
		public var resolver:XMLResolver = new MathMLResolver();
		private var _rootElement:MathElement = new MathElement();
		private var draggedNode:NodeSprite;
		public function MathVis()
		{
			super();
			setStyle("backgroundAlpha", 1.0);
			setStyle("backgroundColor", 0x80A0C0);
			_rootElement.addEventListener(Event.CHANGE, onRootElementChange);
			addEventListener(FlexEvent.CREATION_COMPLETE, initVisualization, false, int.MAX_VALUE);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			visualization.data = new Data(true);
			visualization.addEventListener(VisualizationEvent.UPDATE, onVisualizationUpdate);
			ElementDragger.INSTANCE.addEventListener(ElementDragEvent.ELEMENT_DROP, onElementDrop);
			ElementDragger.INSTANCE.addEventListener(ElementDragEvent.ELEMENT_MOVE, onElementMove);
		}
		override public function set data(v:Object):void
		{
			throw new IllegalOperationError();
		}
		override public function set dataSet(d:*) : void
		{
			throw new IllegalOperationError();
		}
		public function get rootElement():MathElement
		{
			return _rootElement;
		}
		public function set rootElement(v:MathElement):void
		{
			if (_rootElement != v)
			{
				if (_rootElement)
					_rootElement.removeEventListener(Event.CHANGE, onRootElementChange);
				_rootElement = v || new MathElement();
				_rootElement.addEventListener(Event.CHANGE, onRootElementChange);
				invalidateData();
			}
		}
		private function dragNode(node:NodeSprite):void
		{
			if (draggedNode == node)
				return;
			if (draggedNode)
				draggedNode.stopDrag();
			draggedNode = node;
			if (node == null)
				return;
			if (transitioner)
				transitioner.stop();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingNode);
			stage.addEventListener(Event.MOUSE_LEAVE, stopDraggingNode);
			node.startDrag(true);
			//visualization.continuousUpdates = true;
		}
		private function stopDraggingNode(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingNode);
			stage.removeEventListener(Event.MOUSE_LEAVE, stopDraggingNode);
			if (draggedNode)
			{
				draggedNode.stopDrag();
				draggedNode = null;
			}
		}
		private static function filterEdgesAndMissing(d:DataSprite):Boolean
		{
			return d is EdgeSprite || d.data is MissingElement;
		}
		private function initVisualization(event:* = null):void
		{
			visualization.filters = [new DropShadowFilter(3, 45, 0x000066, 0.25, 4, 4, 1, 2)];
			updateVisualization(true);
		}
		private function invalidateData():void
		{
			if (!dataInvalid)
			{
				dataInvalid = true;
				if (stage)
				{
					stage.addEventListener(Event.RENDER, validateData)
					stage.invalidate();
				}
				else
					addEventListener(Event.ADDED_TO_STAGE, validateData);
			}
		}
		private function markSprites(element:MathMLElement, p:Point):void
		{
			const x:Number = p.x;
			const y:Number = p.y;
			visualization.data.visit(function(d:DataSprite):void
				{
					if (d.hitTestPoint(x, y, true))
					{
						if (markedSprites.has(d))
							return;
						var child:MathMLElement = (d is EdgeSprite ? EdgeSprite(d).target.data : d.data)
							as MathMLElement;
						if (child.parent)
						{
							var index:int = child.parent.getChildIndex(child);
							if (child.parent.acceptChildAt(element, index))
							{
								d.filters = EDGE_MARK_FILTERS;
								markedSprites.add(d);
								return;
							}
						}
					}
					markedSprites.remove(d);
					d.filters = null;
				}, null, filterEdgesAndMissing);
		}
		private function onAddedToStage(event:Event):void
		{
			controls = [new TooltipControl(NODE_FILTER, null, onTooltipShow, onTooltipShow),
				new ClickControl(NODE_FILTER, 2, onDoubleClickNode)];
			const layout:ForceDirectedLayout = new ForceDirectedLayout(true);
			layout.defaultSpringLength *= 2.25;
			const edgeFmt:TextFormat = new TextFormat();
			edgeFmt.color = 0xFFFFFF;
			operators = [layout, new Labeler("data.label", "edges", edgeFmt, null, Labeler.LAYER)];
		}
		private function onDoubleClickNode(event:SelectionEvent):void
		{
			const n:NodeSprite = event.item as NodeSprite;
			const element:MathMLElement = n.data as MathMLElement;
			try
			{
				const result:* = resolver.resolveXML(element.mathML);
				// :TODO: dispatch
				trace("RESULT:", result);
			}
			catch (e:Error)
			{
				// :TODO: dispatch
				trace("ERROR IN RESULT - " + e.name + ": " + e.message); 
			}
		}
		private function onElementDrop(event:ElementDragEvent):void
		{
			if (!hitTestPoint(event.position.x, event.position.y));
				trace("NOT OVER VIS");
			if (!markedSprites.empty)
			{
				const d:DataSprite = markedSprites.toVector()[0] as DataSprite;
				markedSprites.clear();
				visualization.data.visit(function(d:DisplayObject):void
					{
						d.filters = null;
					}, null, filterEdgesAndMissing);
				const child:MathMLElement = (d is EdgeSprite ? EdgeSprite(d).source.data : d.data)
					as MathMLElement;
				const parent:MathMLContainer = child.parent;
				const index:int = parent.getChildIndex(child);
				if (parent.acceptChildAt(event.element, index))
				{
					parent.setChildAt(event.element, index);
					return;
				}
			}
			_rootElement.incrementChildren();
			_rootElement.setChildAt(event.element, 0);
		}
		private function onElementMove(event:ElementDragEvent):void
		{
			markSprites(event.element, event.position);
		}
		private function onMouseDown(event:MouseEvent):void
		{
			if (event.target is NodeSprite)
			{
				const node:NodeSprite = event.target as NodeSprite;
				const element:MathMLElement = node.data as MathMLElement;
				if (event.shiftKey && !(element is MissingElement))
					ElementDragger.INSTANCE.currentElement = element.clone();
				else if (event.ctrlKey || element.parent == _rootElement)
				{
					if (element.parent)
						element.parent.removeChild(element);
					if (!(element is MissingElement))
						ElementDragger.INSTANCE.currentElement = element;
				}
				else if (element is MathMLContainer && event.altKey && MathMLContainer(element).canIncrementChildren)
					MathMLContainer(element).incrementChildren();
				else
					dragNode(node);
			}
		}
		private function onRemovedFromStage(event:Event):void
		{
			controls = [];
			operators = [];
		}
		private function onRootElementChange(event:Event):void
		{
			invalidateData();
		}
		private function onTooltipShow(event:TooltipEvent):void
		{
			if (event.node && event.tooltip is TextSprite)
				TextSprite(event.tooltip).text = MathMLElement(event.node.data).toolTipText;
		}
		private function onTransitionEnd(event:TransitionEvent = null):void
		{
			onVisualizationUpdate();
			//if (!draggedNode)
			//	visualization.continuousUpdates = false;
			transitioner = null;
		}
		private function onVisualizationUpdate(event:VisualizationEvent = null):void
		{
			invalidateDisplayList();
			invalidateProperties();
			invalidateSize();
		}
		private function updateVisualization(immediate:Boolean = false):void
		{
			if (!stage || !visualization || !visualization.data)
				return;
			if (transitioner != null)
			{
				transitioner.removeEventListener(TransitionEvent.END, onTransitionEnd);
				transitioner.stop();
			}
			if (visualization.data.nodes.length != 0)
			{
				visualization.visible = true;
				visualization.continuousUpdates = true;
				transitioner = visualization.update(immediate ? 0 : TRANSITION_SECONDS);
				transitioner.addEventListener(TransitionEvent.END, onTransitionEnd, false, 0, true);
				transitioner.play();
			}
			else
			{
				transitioner = null;
				visualization.visible = false;
				visualization.continuousUpdates = false;
			}
		}
		private function validateData(event:Event):void
		{
			IEventDispatcher(event.target).removeEventListener(event.type, validateData);
			if (dataInvalid)
			{
				dataInvalid = false;
				new DataUpdater(visualization.data, _rootElement.toVector(),
					new Point(mouseX, mouseY));
				updateVisualization();
			}
		}
	}
}