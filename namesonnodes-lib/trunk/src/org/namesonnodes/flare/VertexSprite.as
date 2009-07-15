package org.namesonnodes.flare
{
	import flare.vis.data.NodeSprite;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;

	public final class VertexSprite extends NodeSprite
	{
		public static const BORDER_COLOR:uint = 0x330000;
		public static const CORNER_RADIUS:uint = 8;
		public static const FILL_COLOR:uint = 0xC0B003;
		//public static const FILL_COLOR_PARTIALLY_SELECTED:uint = 0xDFCB01;
		public static const FILL_COLOR_SELECTED:uint = 0xFFE700;
		//public static const FILTERS_PARTIALLY_SELECTED:Array = [new GlowFilter(FILL_COLOR_SELECTED, 1, 4, 4, 3, 3)];
		public static const FILTERS_SELECTED:Array = [new GlowFilter(FILL_COLOR_SELECTED, 0.33, 4, 4, 3, 3)];
		public static const HEIGHT:uint = 22;
		public static const LABEL_FILTERS:Array = [new GlowFilter(0xFFFF80, 1, 4, 4, 2, 3)];
		public static const MAX_WIDTH:uint = 75;
		public static const PADDING_BOTTOM:uint = 2;
		public static const PADDING_LEFT:uint = 2;
		public static const PADDING_RIGHT:uint = 4;
		public static const PADDING_TOP:uint = 0;
		public static const TEXT_COLOR:uint = 0x330000;
		public static const UNLABELLED_CORNER_RADIUS:uint = 4;
		public static const UNLABELLED_HEIGHT:uint = 16;
		public static const UNLABELLED_WIDTH:uint = 16;
		public static const MAX_LABEL_WIDTH:uint = MAX_WIDTH - PADDING_LEFT - PADDING_RIGHT;
		private var _selected:Boolean = false;
		private var toolTip:IToolTip;
		public function VertexSprite()
		{
			super();
			mouseEnabled = false;
			buttonMode = true;
			useHandCursor = true;
			_renderer = new VertexRenderer();
			addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
			addEventListener(MouseEvent.MOUSE_OVER, showToolTip);
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				_selected = value;
				VertexRenderer(_renderer).fillColor = _selected ? FILL_COLOR_SELECTED : FILL_COLOR;
				filters = _selected ? FILTERS_SELECTED : [];
				dirty();
			}
		}
		private function hideToolTip(event:MouseEvent):void
		{
			if (toolTip)
			{
				ToolTipManager.destroyToolTip(toolTip);
				toolTip = null;
			}
		}
		/*
		public function selectPartially():void
		{
			_selected = false;
			VertexRenderer(_renderer).fillColor = FILL_COLOR_PARTIALLY_SELECTED;
			filters = FILTERS_PARTIALLY_SELECTED;
			dirty();
		}
		*/
		private function showToolTip(event:MouseEvent):void
		{
			hideToolTip(event);
			if (data.label.length > 0)
				toolTip = ToolTipManager.createToolTip(data.label, stage.mouseX, stage.mouseY);
		}
	}
}

import flare.util.Colors;
import flare.vis.data.render.ShapeRenderer;
import flare.vis.data.DataSprite;

import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;

import flare.vis.data.NodeSprite;
import flash.display.Sprite;
import a3lbmonkeybrain.brainstem.collections.FiniteSet;
import org.namesonnodes.domain.entities.Taxon;
import flashx.textLayout.controls.TLFTextField;
import org.namesonnodes.flare.VertexSprite;

class VertexRenderer extends ShapeRenderer
{
	public var fillColor:uint = VertexSprite.FILL_COLOR;
	private var labelField:TLFTextField;
	private var shine:Shape;
	private var hit:Sprite;
	override public function render(sprite:DataSprite):void
	{
		sprite.graphics.clear();
		const taxa:FiniteSet = sprite.data as FiniteSet;
		var ellipse:int, h:int, w:int, x:int, y:int;
		const labelParts:Array = [];
		for each (var taxon:Taxon in taxa)
		{
			// :TODO: Get identifier labels.
			labelParts.push(taxon.id);
		}
		var label:String = labelParts.sort(Array.NUMERIC).join("/");
		if (label == "")
		{
			if (labelField)
			{
				sprite.removeChild(labelField);
				labelField = null;
			}
			x = -(VertexSprite.UNLABELLED_WIDTH / 2);
			y = -(VertexSprite.UNLABELLED_HEIGHT / 2);
			w = VertexSprite.UNLABELLED_WIDTH;
			h = VertexSprite.UNLABELLED_HEIGHT;
			ellipse = VertexSprite.UNLABELLED_CORNER_RADIUS;
		}
		else
		{
			if (labelField == null)
			{
				labelField = new TLFTextField();
				labelField.text = label;
				labelField.mouseEnabled = false;
				labelField.textColor = VertexSprite.TEXT_COLOR;
				labelField.filters = VertexSprite.LABEL_FILTERS;
				sprite.addChild(labelField);
			}
			else
				labelField.text = label;
			while (labelField.width > VertexSprite.MAX_LABEL_WIDTH)
			{
				if (label.length == 0)
				{
					labelField.text = "";
					break;
				}
				label = label.substr(0, label.length - 1);
				labelField.text = label + "...";
			}
			const w2:int = labelField.width / 2;
			const h2:int = labelField.height / 2;
			labelField.x = -w2;
			labelField.y = -h2;
			x = -w2 - VertexSprite.PADDING_LEFT;
			y = -h2 - VertexSprite.PADDING_TOP;
			w = labelField.width + VertexSprite.PADDING_LEFT + VertexSprite.PADDING_RIGHT;
			h = labelField.height + VertexSprite.PADDING_TOP + VertexSprite.PADDING_BOTTOM;
			ellipse = VertexSprite.CORNER_RADIUS;
		}
		const shadowColor:uint = Colors.darker(fillColor, 0.5);
		const tintColor:uint = Colors.brighter(fillColor, 0.5)
		const matrix:Matrix = new Matrix();
		matrix.createGradientBox(w, h, Math.PI / 2);
		with (sprite.graphics)
		{
			lineStyle(1, VertexSprite.BORDER_COLOR);
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
			beginFill(0xFFFFFF, 0.5);
			drawRoundRect(rect.x + 2, rect.y + 2, rect.width - 4, 4, 4, 4);
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
		//NodeSprite(sprite).size = (w + h) / (TaxonUnitSprite.UNLABELLED_HEIGHT + TaxonUnitSprite.UNLABELLED_WIDTH);
	}
}