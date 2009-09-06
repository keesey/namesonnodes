package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	
	import flare.display.TextSprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.IRenderer;
	
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.namesonnodes.math.editor.elements.DeclareElement;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.elements.MissingElement;
	import org.namesonnodes.math.editor.elements.TaxonIdentifierElement;
	import org.namesonnodes.math.editor.elements.TypedElement;

	public final class ElementRenderer implements IRenderer
	{
		public static const INSTANCE:ElementRenderer = new ElementRenderer();
		private static const MAX_LABEL_WIDTH:Number = 100;
		private static const TEXT_FORMAT_BLACK:TextFormat = createTextFormat(0xFF000000);
		private static const TEXT_FORMAT_WHITE:TextFormat = createTextFormat(0xFFFFFFFF);
		public function ElementRenderer()
		{
			super();
		}
		private static function get randomSpeed():Number
		{
			return Math.random() / 3 + 0.3;
		}
		private static function createTextFormat(color:uint):TextFormat
		{
			const fmt:TextFormat = new TextFormat();
			fmt.align = TextFormatAlign.CENTER;
			fmt.bold = true;
			fmt.color = color;
			fmt.font = "Verdana";
			fmt.size = 12;
			return fmt;
		}
		public function render(sprite:DataSprite):void
		{
			sprite.visible = true;
			sprite.graphics.clear();
			sprite.hitArea = null;
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
			while (sprite.numChildren != 0)
				sprite.removeChildAt(0);
			const element:MathMLElement = sprite.data as MathMLElement; 
			if (element == null)
				return;
			var type:Class = element.resultClass;
			if (type == Boolean)
				renderCircle(sprite, element, 0xFFFFFF, TEXT_FORMAT_BLACK);
			else if (type == Set)
			{
				if (element is TaxonIdentifierElement)
					renderRoundRect(sprite, element, 0x039C7A, TEXT_FORMAT_WHITE);
				else
					renderCircle(sprite, element, 0x039C7A, TEXT_FORMAT_WHITE);
			}
			else if (element is TypedElement)
			{
				type = TypedElement(element).type;
				if (type == Boolean)
					renderRect(sprite, element, 0xFFFFFF, TEXT_FORMAT_BLACK);
				else if (type == Set)
					renderRect(sprite, element, 0x039C7A, TEXT_FORMAT_WHITE);
				else
					renderRect(sprite, element, 0x808080, TEXT_FORMAT_BLACK);
			}
			else
				renderRect(sprite, element, 0x808080, TEXT_FORMAT_BLACK);
		}
		private static function renderCircle(sprite:DataSprite, element:MathMLElement, color:uint, format:TextFormat):void
		{
			const text:TextSprite = new TextSprite(element.label, format);
			text.x = text.width / -2;
			text.y = text.height / -2;
			const radius:Number = Math.max(text.width, text.height) / 2;
			with (sprite.graphics)
			{
				moveTo(0, 0);
				lineStyle(1, color, 1.0, true, LineScaleMode.NONE);
				drawCircle(0, 0, radius + 4);
				lineStyle();
				beginFill(color);
				drawCircle(0, 0, radius + 2);
			}
			const hit:Sprite = new Sprite();
			with (hit.graphics)
			{
				beginFill(0xFF0000, 0.0);
				drawCircle(0, 0, radius + 2);
			}
			sprite.addChild(hit);
			sprite.hitArea = hit;
			sprite.addChild(text);
			if (element is MissingElement)
			{
				sprite.addChildAt(new ExpandingCircle(color, 1, radius + 24, randomSpeed), 0);
				sprite.addChildAt(new ExpandingCircle(color, 1, radius + 24, randomSpeed), 0);
			}
		}
		private static function renderRect(sprite:DataSprite, element:MathMLElement, color:uint, format:TextFormat):void
		{
			const text:TextSprite = new TextSprite(element.label, format);
			text.x = text.width / -2;
			text.y = text.height / -2;
			sprite.addChild(text);
			with (sprite.graphics)
			{
				beginFill(color);
				lineStyle(1, format.color, 1.0, true, LineScaleMode.NONE);
				drawRect(text.x - 2, text.y - 2, text.width + 4, text.height + 4);
			}
		}
		private static function renderRoundRect(sprite:DataSprite, element:MathMLElement, color:uint, format:TextFormat):void
		{
			var label:String = element.label;
			const text:TextSprite = new TextSprite(label, format);
			while (text.width > MAX_LABEL_WIDTH)
				text.text = label = label.substr(0, -1) + "\u2026";
			text.x = text.width / -2;
			text.y = text.height / -2;
			with (sprite.graphics)
			{
				beginFill(color, 0.0);
				lineStyle(1, 0x037A9C, 1.0, true, LineScaleMode.NONE);
				drawRoundRect(text.x - 4, text.y - 4, text.width + 8, text.height + 8, 16);
				lineStyle();
				beginFill(color);
				drawRoundRect(text.x - 2, text.y - 2, text.width + 4, text.height + 4, 16);
				endFill();
			}
			const hit:Sprite = new Sprite();
			with (hit.graphics)
			{
				beginFill(0xFF0000, 0.0);
				drawRoundRect(text.x - 2, text.y - 2, text.width + 4, text.height + 4, 16);
			}
			sprite.addChild(hit);
			sprite.hitArea = hit;
			sprite.addChild(text);
			if (element is MissingElement)
			{
				sprite.addChildAt(new ExpandingRectangle(color, text.width, text.height, 12, randomSpeed, 16), 0);
				sprite.addChildAt(new ExpandingRectangle(color, text.width, text.height, 12, randomSpeed, 16), 0);
			}
		}
	}
}