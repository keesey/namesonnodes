package org.namesonnodes.math.editor.panels
{
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.IRenderer;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import spark.core.SpriteVisualElement;
	
	[Event(name = "resize", type = "flash.events.Event")]
	public final class DataVisualElement extends SpriteVisualElement
	{
		private const dataSprite:DataSprite = new DataSprite();
		public function DataVisualElement()
		{
			super();
			addChild(dataSprite);
		}
		public function set data(value:Object):void
		{
			if (dataSprite.data != value)
			{
				dataSprite.data = value;
				invalidateDataSprite();
			}
		}
		[Bindable(event = "resize")]
		override public function get height() : Number
		{
			return dataSprite.height;
		}
		override public function set height(value:Number):void
		{
		}
		public function set renderer(value:IRenderer):void
		{
			if (dataSprite.renderer != value)
			{
				dataSprite.renderer = value;
				invalidateDataSprite();
			}
		}
		[Bindable(event = "resize")]
		override public function get width() : Number
		{
			return dataSprite.height;
		}
		override public function set width(value:Number):void
		{
		}
		private function invalidateDataSprite():void
		{
			dataSprite.dirty();
			addEventListener(Event.RENDER, onRender, false, int.MAX_VALUE);
			if (stage)
				stage.invalidate();
		}
		private function onRender(event:Event):void
		{
			removeEventListener(Event.RENDER, onRender);
			dataSprite.render();
			const rect:Rectangle = dataSprite.getRect(this);
			dataSprite.x -= rect.x;
			dataSprite.y -= rect.y;
			invalidateParentSizeAndDisplayList();
			dispatchEvent(new Event(Event.RESIZE));
		}
	}
}