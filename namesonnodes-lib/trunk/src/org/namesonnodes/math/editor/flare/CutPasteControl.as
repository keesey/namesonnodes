package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	
	import flare.vis.controls.IControl;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathElement;
	import org.namesonnodes.math.editor.elements.MathMLElement;

	public final class CutPasteControl implements IControl
	{
		private var _object:InteractiveObject;
		private var rootElement:MathElement;
		public function CutPasteControl(rootElement:MathElement)
		{
			super();
			assertNotNull(rootElement);
			this.rootElement = rootElement;
		}
		public function get object():InteractiveObject
		{
			return _object;
		}
		public function attach(obj:InteractiveObject):void
		{
			if (_object != obj)
			{
				detach();
				_object = obj;
				if (_object != null)
					_object.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		public function detach():InteractiveObject
		{
			if (_object)
			{
				const o:InteractiveObject = _object;
				_object = null;
				o.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				return o;
			}
			return null;
		}
		public function initialized(document:Object, id:String):void
		{
		}
		private function onMouseDown(event:MouseEvent):void
		{
			var element:MathMLElement;
			if (event.target is NodeSprite)
			{
				element = NodeSprite(event.target).data as MathMLElement;
				if (element)
				{
					element.parent.removeChild(element);
					if (element.parent != null && element.parent != rootElement)
						ElementDragger.INSTANCE.currentElement = element;
				}
			}
			else if (event.target is EdgeSprite)
			{
				const e:EdgeSprite = event.target as EdgeSprite;
				element = e.source.data as MathMLElement;
				if (element.parent)
				{
					element.parent.removeChild(element);
					rootElement.incrementChildren();
					rootElement.setChildAt(element, rootElement.numChildren - 1);
				}
			}
		}
	}
}