package org.namesonnodes.math.editor.flare
{
	import flare.display.TextSprite;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.elements.MissingElement;
	
	public final class BooleanSprite extends Sprite
	{
		private static const ALPHAS:Array = [1.0, 1.0, 1.0, 1.0, 1.0];
		private static const BEACON_RATIO_PER_FRAME:Number = 0.05;
		private static const BEACON_COLOR:uint = 0xFFC040;
		private static const BORDER_COLOR:uint = 0xFFC040;
		private static const FILL_COLOR:uint = 0xFFF060;
		private static const MARGIN_BOTTOM:Number = 0;
		private static const MARGIN_LEFT:Number = 1;
		private static const MARGIN_RADIUS:Number = 0;
		private static const MARGIN_RIGHT:Number = 0;
		private static const MARGIN_TOP:Number = 1;
		private static const RATIOS:Array = [0, 63, 168, 191, 255];
		private static const SHADOW_COLOR:uint = 0xFFC040;
		private static const TINT_COLOR:uint = 0xFFFFFF;
		private static const COLORS:Array = [SHADOW_COLOR, FILL_COLOR, TINT_COLOR, FILL_COLOR, SHADOW_COLOR];
		private const backShape:Shape = new Shape();
		private const beaconShape:Shape = new Shape();
		private const textSprite:TextSprite = new TextSprite();
		private var beaconMaxRadius:Number = 20.0;
		private var beaconMinRadius:Number = 0.0;
		private var beaconRatio:Number = 0.0;
		public function BooleanSprite(element:MathMLElement)
		{
			super();
			textSprite.text = element.label.toUpperCase();
			const w:Number = textSprite.width;
			const h:Number = textSprite.height;
			textSprite.x = -w / 2;
			textSprite.y = -h / 2;
			textSprite.size = 10;
			const matrix:Matrix = new Matrix();
			if (element is MissingElement)
			{
				beaconRatio = 0.0;
				addChild(beaconShape);
				addEventListener(Event.ENTER_FRAME, updateBeacon);
				const radius:Number = beaconMinRadius = Math.max(w, h) / 2 + MARGIN_RADIUS;
				beaconMaxRadius = beaconMinRadius * 2;
				matrix.createGradientBox(radius * 2, radius * 2, 0, 0, radius / 2);
				with (backShape.graphics)
				{
					moveTo(0, 0);
					lineStyle(1, BORDER_COLOR, 1.0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
					beginGradientFill(GradientType.RADIAL, COLORS, ALPHAS, RATIOS, matrix);
					drawCircle(0, 0, radius);
				}
			}
			else
			{
				backShape.x = textSprite.x - MARGIN_LEFT;
				backShape.y = textSprite.y - MARGIN_TOP;
				matrix.createGradientBox(w, h, Math.PI / 2);
				with (backShape.graphics)
				{
					moveTo(0, 0);
					lineStyle(2, BORDER_COLOR, 1.0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
					beginGradientFill(GradientType.LINEAR, COLORS, ALPHAS, RATIOS, matrix);
					drawRect(0, 0, w + MARGIN_LEFT + MARGIN_RIGHT, h + MARGIN_BOTTOM + MARGIN_TOP);
				}
			}
			addChild(backShape);
			addChild(textSprite);
		}
		private function updateBeacon(event:Event):void
		{
			beaconRatio += BEACON_RATIO_PER_FRAME;
			if (beaconRatio > 1.0)
				beaconRatio = 0.0;
			const radius:Number = beaconMinRadius * (1 - beaconRatio) + beaconMaxRadius * beaconRatio;
			with (beaconShape.graphics)
			{
				clear();
				lineStyle(1, BEACON_COLOR, 1.0 - beaconRatio);
				drawCircle(0, 0, radius);
			}
		}
	}
}