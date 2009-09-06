package org.namesonnodes.math.editor.flare
{
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	
	public final class ExpandingCircle extends Shape
	{
		private var color:uint;
		private var maxRadius:Number;
		private var minRadius:Number;
		private var radiusPerFrame:Number;
		private var radius:Number;
		public function ExpandingCircle(color:uint, minRadius:Number, maxRadius:Number,
			radiusPerFrame:Number)
		{
			super();
			this.color = color;
			radius = this.minRadius = minRadius;
			this.maxRadius = maxRadius;
			this.radiusPerFrame = radiusPerFrame;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(event:Event):void
		{
			radius += radiusPerFrame;
			while (radius > maxRadius)
				radius -= (maxRadius - minRadius);
			with (graphics)
			{
				clear();
				lineStyle(1, color, 1.0, true, LineScaleMode.NONE);
				drawCircle(0, 0, radius);
			}
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}