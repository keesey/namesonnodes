package org.namesonnodes.math.editor.flare
{
	import flare.display.DirtySprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.ShapeRenderer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;

	public final class ElementRenderer extends ShapeRenderer
	{
		private var sprite:DirtySprite;
		public function ElementRenderer(data:IEventDispatcher)
		{
			super();
			//data.addEventListener(Event.CHANGE, onChange);
		}
		private function onChange(event:Event):void
		{
			if (sprite)
				sprite.dirty();
		}
		override public function render(sprite:DataSprite):void
		{
			this.sprite = sprite;
			sprite.graphics.clear();
			sprite.hitArea = null;
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
			while (sprite.numChildren != 0)
				sprite.removeChildAt(0);
			const element:MathMLElement = sprite.data as MathMLElement;
			var elementSprite:Sprite;
			// :TODO: handle null differently
			if (element.resultClass == Boolean || element.resultClass == null)
				elementSprite = new BooleanSprite(element);
			else with (sprite.graphics)
			{
				beginFill(0xFF0000, 1.0);
				drawCircle(0, 0, 10);
			}
			if (elementSprite)
			{
				sprite.addChild(elementSprite);
				sprite.hitArea = elementSprite;
			}
		}
	}
}