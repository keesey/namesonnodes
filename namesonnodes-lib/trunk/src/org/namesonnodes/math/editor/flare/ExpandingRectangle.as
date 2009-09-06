package org.namesonnodes.math.editor.flare
{
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	
	public final class ExpandingRectangle extends Shape
	{
		private var color:uint;
		private var ellipseSize:Number;
		private var growth:Number = 0.0;
		private var growthPerFrame:Number;
		private var h:Number;
		private var maxGrowth:Number;
		private var w:Number;
		public function ExpandingRectangle(color:uint, w:Number, h:Number, maxGrowth:Number,
			growthPerFrame:Number, ellipseSize:Number)
		{
			super();
			this.color = color;
			this.w = w;
			this.h = h;
			this.maxGrowth = maxGrowth;
			this.ellipseSize = ellipseSize;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(event:Event):void
		{
			growth += growthPerFrame
			while (growth > maxGrowth)
				growth -= maxGrowth;
			const w:Number = this.w + growth;
			const h:Number = this.h + growth;
			with (graphics)
			{
				clear();
				lineStyle(1, color, 1.0, true, LineScaleMode.NONE);
				drawRoundRect(-w/2, -h/2, w, h, ellipseSize);
			}
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}