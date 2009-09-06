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
	
	import org.namesonnodes.math.editor.elements.MathMLElement;
	import org.namesonnodes.math.editor.elements.MissingElement;

	public final class ElementRenderer implements IRenderer
	{
		public static const INSTANCE:ElementRenderer = new ElementRenderer();
		private static const TEXT_FORMAT_BLACK:TextFormat = createTextFormat(0xFF000000);
		private static const TEXT_FORMAT_WHITE:TextFormat = createTextFormat(0xFFFFFFFF);
		public function ElementRenderer()
		{
			super();
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
			const type:Class = element.resultClass;
			if (type == Boolean)
				renderBoolean(sprite, element);
			else if (type == Set)
				renderSet(sprite, element);
			else
				renderOther(sprite, element);
		}
		private static function renderBoolean(sprite:DataSprite, element:MathMLElement):void
		{
			const text:TextSprite = new TextSprite(element.label, TEXT_FORMAT_BLACK);
			text.x = text.width / -2;
			text.y = text.height / -2;
			const radius:Number = Math.max(text.width, text.height) / 2;
			with (sprite.graphics)
			{
				moveTo(0, 0);
				lineStyle(1, 0xFFFFFF, 1.0, true, LineScaleMode.NONE);
				drawCircle(0, 0, radius + 4);
				lineStyle();
				beginFill(0xFFFFFF);
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
				sprite.addChildAt(new ExpandingCircle(0xFFFFFF, 1, radius + 24, Math.random() / 2 + 0.1), 0);
				sprite.addChildAt(new ExpandingCircle(0xFFFFFF, 1, radius + 24, Math.random() / 2 + 0.1), 0);
			}
		}
		private static function renderOther(sprite:DataSprite, element:MathMLElement):void
		{
			const text:TextSprite = new TextSprite(element.label, TEXT_FORMAT_WHITE);
			text.x = text.width / -2;
			text.y = text.height / -2;
			sprite.addChild(text);
			with (sprite.graphics)
			{
				beginFill(0x000000);
				drawRect(text.x - 2, text.y - 2, text.width + 4, text.height + 4);
			}
		}
		private static function renderSet(sprite:DataSprite, element:MathMLElement):void
		{
			const text:TextSprite = new TextSprite(element.label, TEXT_FORMAT_BLACK);
			text.x = text.width / -2;
			text.y = text.height / -2;
			sprite.addChild(text);
			with (sprite.graphics)
			{
				beginFill(0xFF0000, 0.0);
				lineStyle(1, 0x037A9C, 1.0, true, LineScaleMode.NONE);
				drawRoundRect(text.x - 4, text.y - 4, text.width + 8, text.height + 8, 16);
				lineStyle();
				beginFill(0x037A9C);
				drawRoundRect(text.x - 2, text.y - 2, text.width + 4, text.height + 4, 16);
				endFill();
			}
		}
	}
}