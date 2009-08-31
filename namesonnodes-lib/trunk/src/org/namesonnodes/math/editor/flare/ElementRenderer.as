package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	
	import flare.display.DirtySprite;
	import flare.util.Colors;
	import flare.vis.data.DataSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.render.ShapeRenderer;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.controls.TLFTextField;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;

	public final class ElementRenderer extends ShapeRenderer
	{
		public static const BORDER_COLOR:uint = 0x000000;
		public static const CORNER_RADIUS:uint = 8;
		public static const FILL_COLORS:Dictionary = createFillColors();
		public static const FILTERS_SELECTED:Array = [new GlowFilter(0xFFFFFF, 0.5, 4, 4, 3, 3)];
		public static const HEIGHT:uint = 22;
		public static const LABEL_FILTERS:Array = [new GlowFilter(0xFFFFFF, 0.75, 4, 4, 2, 3)];
		public static const PADDING_BOTTOM:uint = 6;
		public static const PADDING_LEFT:uint = 4;
		public static const PADDING_RIGHT:uint = 6;
		public static const PADDING_TOP:uint = 2;
		public static const TEXT_COLOR:uint = 0x000000;
		private var labelField:TLFTextField;
		private var shine:Shape;
		private var hit:Sprite;
		private var sprite:DirtySprite;
		public function ElementRenderer(data:IEventDispatcher)
		{
			super();
			data.addEventListener(Event.CHANGE, onChange);
		}
		private function onChange(event:Event):void
		{
			sprite.dirty();
		}
		private static function createFillColors():Dictionary
		{
			const d:Dictionary = new Dictionary();
			d[Object] = 0xE0E0E0;
			d[null] = 0x000000;
			d[Boolean] = 0xFFFF80;
			d[FiniteSet] = 0x80D0F0;
			return d;
		}
		override public function render(sprite:DataSprite):void
		{
			this.sprite = sprite;
			const element:MathMLElement = sprite.data as MathMLElement;
			const fillColor:uint = FILL_COLORS[element.resultClass]
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
			sprite.graphics.clear();
			var ellipse:int, h:int, w:int, x:int, y:int;
			if (labelField == null)
			{
				labelField = new TLFTextField();
				labelField.text = element.label;
				labelField.mouseEnabled = false;
				labelField.mouseEnabled = false;
				labelField.textColor = TEXT_COLOR;
				labelField.filters = LABEL_FILTERS;
				sprite.addChild(labelField);
			}
			else
				labelField.text = element.label;
			const w2:int = labelField.textWidth / 2;
			const h2:int = labelField.textHeight / 2;
			labelField.x = -w2;
			labelField.y = -h2;
			x = -w2 - PADDING_LEFT;
			y = -h2 - PADDING_TOP;
			w = labelField.textWidth + PADDING_LEFT + PADDING_RIGHT;
			h = labelField.textHeight + PADDING_TOP + PADDING_BOTTOM;
			ellipse = CORNER_RADIUS;
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