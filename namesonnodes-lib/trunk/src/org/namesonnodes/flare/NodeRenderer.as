package org.namesonnodes.flare
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	
	import flare.util.Colors;
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.ShapeRenderer;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.controls.TLFTextField;
	
	import org.namesonnodes.domain.nodes.Node;

	public final class NodeRenderer extends ShapeRenderer
	{
		public static const BORDER_COLOR:uint = 0x000000;
		public static const CORNER_RADIUS:uint = 8;
		public static const FILL_COLOR:uint = 0x80D0F0;
		//public static const FILL_COLOR_PARTIALLY_SELECTED:uint = 0xDFCB01;
		public static const FILL_COLOR_SELECTED:uint = 0xC0FFFF;
		//public static const FILTERS_PARTIALLY_SELECTED:Array = [new GlowFilter(FILL_COLOR_SELECTED, 1, 4, 4, 3, 3)];
		public static const FILTERS_SELECTED:Array = [new GlowFilter(FILL_COLOR_SELECTED, 0.33, 4, 4, 3, 3)];
		public static const HEIGHT:uint = 22;
		public static const LABEL_FILTERS:Array = [new GlowFilter(0xC0FFFF, 1, 4, 4, 2, 3)];
		public static const MAX_WIDTH:uint = 100;
		public static const PADDING_BOTTOM:uint = 6;
		public static const PADDING_LEFT:uint = 4;
		public static const PADDING_RIGHT:uint = 6;
		public static const PADDING_TOP:uint = 2;
		public static const TEXT_COLOR:uint = 0x000000;
		public static const UNLABELLED_CORNER_RADIUS:uint = 4;
		public static const UNLABELLED_HEIGHT:uint = 16;
		public static const UNLABELLED_WIDTH:uint = 16;
		public static const MAX_LABEL_WIDTH:uint = MAX_WIDTH - PADDING_LEFT - PADDING_RIGHT;
		public var fillColor:uint = FILL_COLOR;
		private var labelField:TLFTextField;
		private var shine:Shape;
		private var hit:Sprite;
		override public function render(sprite:DataSprite):void
		{
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
			sprite.graphics.clear();
			var ellipse:int, h:int, w:int, x:int, y:int;
			var label:String = Node(sprite.data).label;
			if (!isNonEmptyString(label))
			{
				if (labelField)
				{
					sprite.removeChild(labelField);
					labelField = null;
				}
				x = -(UNLABELLED_WIDTH / 2);
				y = -(UNLABELLED_HEIGHT / 2);
				w = UNLABELLED_WIDTH;
				h = UNLABELLED_HEIGHT;
				ellipse = UNLABELLED_CORNER_RADIUS;
			}
			else
			{
				if (labelField == null)
				{
					labelField = new TLFTextField();
					labelField.text = label;
					labelField.mouseEnabled = false;
					labelField.mouseEnabled = false;
					labelField.textColor = TEXT_COLOR;
					labelField.filters = LABEL_FILTERS;
					sprite.addChild(labelField);
				}
				else
					labelField.text = label;
				while (labelField.textWidth > MAX_LABEL_WIDTH)
				{
					if (label.length == 0)
					{
						labelField.text = "";
						break;
					}
					label = label.substr(0, label.length - 1);
					labelField.text = label + "...";
				}
				const w2:int = labelField.textWidth / 2;
				const h2:int = labelField.textHeight / 2;
				labelField.x = -w2;
				labelField.y = -h2;
				x = -w2 - PADDING_LEFT;
				y = -h2 - PADDING_TOP;
				w = labelField.textWidth + PADDING_LEFT + PADDING_RIGHT;
				h = labelField.textHeight + PADDING_TOP + PADDING_BOTTOM;
				ellipse = CORNER_RADIUS;
			}
			const shadowColor:uint = Colors.darker(fillColor, 0.5);
			const tintColor:uint = Colors.brighter(fillColor, 0.5)
			const matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, Math.PI / 2);
			with (sprite.graphics)
			{
				lineStyle(1, BORDER_COLOR);
				beginFill(fillColor);
					beginGradientFill(GradientType.LINEAR, [shadowColor, fillColor, tintColor, fillColor, shadowColor],
						[1.0, 1.0, 1.0, 1.0, 1.0], [0, 63, 168, 191, 255], matrix);
				drawRoundRect(x, y, w, h, ellipse, ellipse);
			}
			if (shine == null)
			{
				shine = new Shape();
				sprite.addChild(shine);
			}
			var rect:Rectangle = sprite.getBounds(sprite);
			with (shine.graphics)
			{
				clear();
				beginFill(0xFFFFFF, 0.75);
				drawRoundRect(rect.x + 2, rect.y + 2, rect.width - 4, 4, 4, 4);
			}
			if (labelField)
			{
				const labelIndex:uint = sprite.getChildIndex(labelField);
				if (sprite.getChildIndex(shine) > labelIndex)
					sprite.setChildIndex(shine, labelIndex);
			}
			if (hit == null)
			{
				hit = new Sprite();
				hit.visible = false;
				sprite.addChild(hit);
				sprite.hitArea = hit;
			}
			with (hit.graphics)
			{
				clear();
				beginFill(0xFF0000);
				drawRoundRect(x, y, w, h, ellipse, ellipse);
			}
		}
	}
}