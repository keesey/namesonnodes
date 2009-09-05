package org.namesonnodes.math.editor.flare
{
	import flare.display.DirtySprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.ShapeRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;
	
	import spark.components.Group;

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
			sprite.visible = true;
			sprite.graphics.clear();
			sprite.hitArea = null;
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
			while (sprite.numChildren != 0)
				sprite.removeChildAt(0);
			const element:MathMLElement = sprite.data as MathMLElement;
			const group:Group = new Group();
			group.addElement(element.graphics);
			sprite.addChild(group);
			sprite.hitArea = group;
		}
	}
}