package org.namesonnodes.flare
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableCollection;
	
	import flare.animate.TransitionEvent;
	import flare.animate.Transitioner;
	import flare.flex.FlareVis;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.ArrowType;
	import flare.vis.events.VisualizationEvent;
	import flare.vis.operator.layout.Layout;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import mx.events.FlexEvent;

	public final class NodeGraphVis extends FlareVis
	{
		public static const SELECTION_FILL_ALPHA:Number = 0.25;
		public static const SELECTION_FILL_COLOR:uint = 0xFFFF80;
		public static const SELECTION_LINE_ALPHA:Number = 1.0;
		public static const SELECTION_LINE_COLOR:uint = 0xFFFF00;
		public static const TRANSITION_SECONDS:Number = 0.5;
		private var _layout:Layout;
		private var _selection:FiniteSet = EmptySet.INSTANCE;
		private var transitioner:Transitioner;
		public function NodeGraphVis(data:Data = null)
		{
			super(data);
			addEventListener(FlexEvent.CREATION_COMPLETE, initVisualization, false, int.MAX_VALUE);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			visualization.addEventListener(VisualizationEvent.UPDATE, onVisualizationUpdate);
		}
		override public function set data(v:Object):void
		{
			super.data = v;
			updateVisualization();
		}
		override public function set dataSet(d:*) : void
		{
			super.dataSet = d;
			updateVisualization();
		}
		public function get layout():Layout
		{
			return _layout;
		}
		public function set layout(value:Layout):void
		{
			if (_layout != value)
			{
				if (_layout)
					visualization.operators.remove(_layout);
				_layout = value;
				visualization.operators.add(_layout);
				updateVisualization();
			}
		}
		public function get selection():FiniteSet
		{
			return _selection;
		}
		public function set selection(value:FiniteSet):void
		{
			var node:NodeSprite;
			if (value.empty)
			{
				for each (node in visualization.data.nodes)
					markNode(node, false);
				_selection = EmptySet.INSTANCE;
			}
			else
			{
				_selection = new HashSet();
				for each (node in visualization.data.nodes)
				{
					var selected:Boolean = value.has(node.data);
					markNode(node, selected);
					if (selected)
						MutableCollection(_selection).add(node.data);
				}
			}
		}
		public function set selectionArea(value:Rectangle):void
		{
			with (graphics)
			{
				clear();
				if (value != null)
				{
					moveTo(value.x, value.y);
					lineStyle(1, SELECTION_LINE_COLOR, SELECTION_LINE_ALPHA);
					beginFill(SELECTION_FILL_COLOR, SELECTION_FILL_ALPHA);
					drawRect(value.x, value.y, value.width, value.height);
				}
			}
		}
		public function findDataByArea(area:Rectangle):FiniteSet
		{
			var result:HashSet = new HashSet();
			for each (var node:NodeSprite in visualization.data.nodes)
			{
				if (area.intersects(node.getRect(this)))
					result.add(node.data);
			}
			return result.empty ? EmptySet.INSTANCE : result;
		}
		private function initVisualization(event:* = null):void
		{
			visualization.filters = [new DropShadowFilter(3, 45, 0x000066, 0.25, 4, 4, 1, 2)];
			updateVisualization(true);
		}
		private function killContinuousUpdates(event:Event = null):void
		{
			if (event)
				removeEventListener(event.type, killContinuousUpdates);
			visualization.continuousUpdates = false;
		}
		private static function markNode(node:NodeSprite, marked:Boolean):void
		{
			//:TODO:
		}
		private function onAddedToStage(event:Event):void
		{
			if (_layout == null)
				layout = new OptimalTentDAGLayout();
				//layout = new NodeLinkTreeLayout();//LayoutController.DEFAULT_FACTORY.createLayout(Orientation.LEFT_TO_RIGHT);
		}
		private function onTransitionEnd(event:TransitionEvent):void
		{
			onVisualizationUpdate();
			if (stage)
			{
				addEventListener(Event.RENDER, killContinuousUpdates);
				stage.invalidate();
			}
			else killContinuousUpdates();
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
				transitioner = visualization.update(immediate ? 0.1 : TRANSITION_SECONDS);
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
	}
}