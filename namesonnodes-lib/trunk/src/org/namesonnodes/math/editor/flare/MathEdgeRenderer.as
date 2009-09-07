package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	
	import flare.display.TextSprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.EdgeRenderer;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public final class MathEdgeRenderer extends EdgeRenderer
	{
		public static const INSTANCE:MathEdgeRenderer = new MathEdgeRenderer();
		private static const MIDPOINT_RADIUS:Number = 5;
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
			const label:String = d.data.label;
			const hasLabel:Boolean = isNonEmptyString(label);
			super.render(d);
			const mid:Point = Point.interpolate(sourcePoint, targetPoint, 0.5);
			with (d.graphics)
			{
				moveTo(mid.x, mid.y);
				beginFill(d.fillColor, d.fillAlpha);
			}
			if (hasLabel)
			{
				var text:TextSprite;
				var textContainer:Sprite;
				if (d.numChildren == 0)
				{
					textContainer = new Sprite();
					text = new TextSprite(label, TEXT_FORMAT);
					textContainer.addChild(text);
					d.addChild(textContainer);
				}
				else
				{
					textContainer = d.getChildAt(0) as Sprite;
					if (textContainer.numChildren == 0)
					{
						text = new TextSprite(label, TEXT_FORMAT);
						textContainer.addChild(text);
					}
					else
						text = textContainer.getChildAt(0) as TextSprite;
				}
				text.x = -text.width / 2;
				text.y = -text.height / 2;
				textContainer.x = mid.x;
				textContainer.y = mid.y;
				//textContainer.rotation = Math.atan2(target.y - source.y, target.x - source.x)
				//	* 180 / Math.PI + 90;
				//if (textContainer.rotation > 90 || textContainer.rotation < -90)
				//	textContainer.rotation += 180; 
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