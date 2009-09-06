package org.namesonnodes.math.editor.panels
{
	import flare.vis.data.DataSprite;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.IFactory;
	
	import org.namesonnodes.flare.NullRenderer;
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.flare.ElementRenderer;
	import org.namesonnodes.math.editor.flare.MathVis;
	
	public final class ElementButton extends Canvas
	{
		private const dataSprite:DataSprite = new DataSprite();
		private var _elementFactory:IFactory;
		public function ElementButton()
		{
			super();
			rawChildren.addChild(dataSprite);
			buttonMode = true;
			hitArea = dataSprite;
			visible = false;
			filters = MathVis.VIS_FILTERS;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
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
						dataSprite.renderer = ElementRenderer.INSTANCE;
						dataSprite.data = element;
						dataSprite.dirty();
						visible = true;
						toolTip = element.toolTipText;
						return;
					}
					else
					{
						dataSprite.renderer = NullRenderer.INSTANCE;
						dataSprite.data = null;
						toolTip = null;
					}
				}
				visible = false;
			}
		}
		private function onMouseDown(event:MouseEvent):void
		{
			if (_elementFactory)
				ElementDragger.INSTANCE.currentElement = _elementFactory.newInstance() as MathMLElement;
		}
	}
}