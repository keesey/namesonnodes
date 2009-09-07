package org.namesonnodes.math.editor.elements
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.IVisualElement;
	
	import spark.primitives.supportClasses.GraphicElement;
	
	[Event(name = "change", type = "flash.events.Event")]
	public class AbstractElement extends EventDispatcher
	{
		private var _parent:MathMLContainer;
		public function AbstractElement()
		{
			super();
			if (!(this is MathMLElement))
				throw new Error("Instantiation of a pseudo-abstract class.");
		}
		public function get fontFamily():String
		{
			return "Verdana";
		}
		public function get fontSize():uint
		{
			return 10;
		}
		public final function get parent():MathMLContainer
		{
			return _parent;
		}
		public final function set parent(v:MathMLContainer):void
		{
			if (v != null && !v.hasChild(this as MathMLElement))
				throw new ArgumentError("Invalid parent assignment: " + this + ".parent != " + v);
			if (_parent != v)
			{
				_parent = v;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		override public function toString():String
		{
			try
			{
				return "[MathMLElement " + MathMLElement(this).label + "]";
			}
			catch (e:Error)
			{
				return "[MathMLElement <" + e.name + ": " + e.message + ">]";
			}
			return "[MathMLElement]";
		}
	}
}