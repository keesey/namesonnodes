package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	
	import flare.display.TextSprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.EdgeRenderer;
	
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public final class MathEdgeRenderer extends EdgeRenderer
	{
		public static const INSTANCE:MathEdgeRenderer = new MathEdgeRenderer();
		private static const MIDPOINT_RADIUS:Number = 4;
		private static const TEXT_FORMAT:TextFormat = createTextFormat();
		public function MathEdgeRenderer()
		{
			super();
		}
		private static function createTextFormat():TextFormat
		{
			const fmt:TextFormat = new TextFormat();
			fmt.align = TextFormatAlign.CENTER;
			fmt.bold = true;
			fmt.color = 0xFFFFFF;
			fmt.font = "Verdana";
			fmt.size = 12;
			return fmt;
		}
		override public function render(d:DataSprite) : void
		{
			const source:NodeSprite = EdgeSprite(d).source;
			const target:NodeSprite = EdgeSprite(d).target;
			const sourcePoint:Point = new Point(source.x, source.y);
			const targetPoint:Point = new Point(target.x, target.y);
			if (sourcePoint.equals(targetPoint))
			{
				d.graphics.clear();
				return;
			}
			const mid:Point = Point.interpolate(sourcePoint, targetPoint, 0.5);
			super.render(d);
			with (d.graphics)
			{
				moveTo(mid.x, mid.y);
				beginFill(d.fillColor, d.fillAlpha);
			}
			const label:String = d.data.label;
			if (isNonEmptyString(label))
			{
				var text:TextSprite;
				if (d.numChildren == 0)
				{
					text = new TextSprite(label, TEXT_FORMAT);
					d.addChild(text);
				}
				else
				{
					text = d.getChildAt(0) as TextSprite;
					text.text = label;
				}
				text.x = mid.x - text.width / 2;
				text.y = mid.y - text.height / 2;
			}
			else
			{
				while (d.numChildren != 0)
					d.removeChildAt(0);
				d.graphics.drawCircle(mid.x, mid.y, MIDPOINT_RADIUS);
			}
		}
	}
}