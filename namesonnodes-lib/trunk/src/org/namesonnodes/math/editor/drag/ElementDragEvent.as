package org.namesonnodes.math.editor.drag
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;
	
	public final class ElementDragEvent extends Event
	{
		public static const ELEMENT_DROP:String = "elementDrop";
		public static const ELEMENT_MOVE:String = "elementMove";
		private var _element:MathMLElement;
		private var _position:Point;
		public function ElementDragEvent(type:String, element:MathMLElement, position:Point)
		{
			super(type);
			_element = element;
			_position = position.clone();
		}
		public function get element():MathMLElement
		{
			return _element;
		}
		public function get position():Point
		{
			return _position.clone();
		}
		override public function clone() : Event
		{
			return new ElementDragEvent(type, element, _position);
		}
		override public function toString() : String
		{
			return formatToString("ElementDragEvent", "type", "element", "position"); 
		}
	}
}