package org.namesonnodes.math.editor.panels
{
	import flare.vis.data.DataSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;
	
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.flare.ElementRenderer;
	import org.namesonnodes.math.editor.flare.MathVis;
	
	import spark.core.SpriteVisualElement;
	
	public final class ElementButton extends SpriteVisualElement
	{
		private const dataSprite:DataSprite = new DataSprite();
		private var _elementFactory:IFactory;
		private var toolTip:IToolTip;
		private var toolTipText:String;
		public function ElementButton()
		{
			super();
			dataSprite.renderer = ElementRenderer.INSTANCE;
			addChild(dataSprite);
			buttonMode = true;
			hitArea = dataSprite;
			visible = false;
			filters = MathVis.VIS_FILTERS;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		public function get elementFactory():IFactory
		{
			return _elementFactory;
		}
		public function set elementFactory(v:IFactory):void
		{
			if (_elementFactory != v)
			{
				_elementFactory = v;
				if (_elementFactory)
				{
					const element:MathMLElement = _elementFactory.newInstance() as MathMLElement;
					if (element)
					{
						dataSprite.data = element;
						dataSprite.dirty();
						visible = true;
						toolTipText = element.toolTipText;
						return;
					}
					else
						toolTipText = null;
				}
				visible = false;
			}
		}
		private function closeToolTip():void
		{
			if (toolTip)
			{
				ToolTipManager.destroyToolTip(toolTip);
				toolTip = null;
			}
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		private function onMouseDown(event:MouseEvent):void
		{
			if (_elementFactory)
				ElementDragger.INSTANCE.currentElement = _elementFactory.newInstance() as MathMLElement;
		}
		private function onMouseOut(event:MouseEvent):void
		{
			closeToolTip();
		}
		private function onMouseOver(event:MouseEvent):void
		{
			closeToolTip();
			toolTip = ToolTipManager.createToolTip(toolTipText, stage.mouseX, stage.mouseY);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			closeToolTip();
		}
	}
}