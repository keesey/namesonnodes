package org.namesonnodes.math.editor.panels
{
	import flare.vis.data.DataSprite;
	
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.flare.ElementRenderer;
	
	import spark.core.SpriteVisualElement;
	
	public final class ElementButton extends SpriteVisualElement
	{
		private const dataSprite:DataSprite = new DataSprite();
		private var _elementFactory:IFactory; 
		public function ElementButton()
		{
			super();
			addChild(dataSprite);
			buttonMode = true;
			hitArea = dataSprite;
			visible = false;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
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
						new ElementRenderer(element).render(dataSprite);
						dataSprite.x = dataSprite.width / 2;
						dataSprite.y = dataSprite.height / 2;
						visible = true;
						return;
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