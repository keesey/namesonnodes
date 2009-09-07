package org.namesonnodes.math.editor.drag
{
	import flare.vis.data.DataSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import mx.core.FlexGlobals;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.flare.ElementRenderer;
	
	public final class ElementDragger extends EventDispatcher
	{
		private static const FILTERS:Array = [new DropShadowFilter(20, 35, 0x000066, 0.33, 0, 0)];
		public static const INSTANCE:ElementDragger = new ElementDragger();
		private var _currentElement:MathMLElement;
		private var dataSprite:DataSprite;
		private var dragging:Boolean = false;
		public function ElementDragger()
		{
			super();
		}
		public function get currentElement():MathMLElement
		{
			return _currentElement;
		}
		public function set currentElement(v:MathMLElement):void
		{
			if (_currentElement != v)
			{
				_currentElement = v;
				if (dataSprite)
					stopDrag();
				if (v != null)
				{
					dataSprite = new DataSprite();
					dataSprite.filters = FILTERS;
					dataSprite.data = v;
					dataSprite.renderer = ElementRenderer.INSTANCE;
					dataSprite.dirty();
					startDrag();
				}
			}
		}
		public function get displayObject():DisplayObject
		{
			return dataSprite;
		}
		private function get stage():Stage
		{
			return DisplayObject(FlexGlobals.topLevelApplication).stage;
		}
		private function onMouseLeave(event:Event):void
		{
			currentElement = null;
		}
		private function onMouseMove(event:MouseEvent):void
		{
			const pos:Point = new Point(stage.mouseX, stage.mouseY);
			dispatchEvent(new ElementDragEvent(ElementDragEvent.ELEMENT_MOVE, _currentElement, pos));
		}
		private function onMouseUp(event:MouseEvent):void
		{
			const oldElement:MathMLElement = _currentElement;
			const pos:Point = new Point(stage.mouseX, stage.mouseY);
			currentElement = null;
			dispatchEvent(new ElementDragEvent(ElementDragEvent.ELEMENT_DROP, oldElement, pos));
		}
		private function startDrag():void
		{
			if (dragging)
				return;
			dragging = true;
			stage.addChild(dataSprite);
			dataSprite.startDrag(true);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Mouse.hide();
		}
		private function stopDrag():void
		{
			if (!dragging)
				return;
			dragging = false;
			stage.removeChild(dataSprite);
			dataSprite.stopDrag();
			dataSprite = null;
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Mouse.show();
		}
	}
}