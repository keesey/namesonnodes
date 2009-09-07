package org.namesonnodes.math.editor.elements
{
	import flash.events.IEventDispatcher;

	[Event(name = "change", type = "flash.events.Event")]
	public interface MathMLElement extends IEventDispatcher
	{
		function get fontFamily():String;
		function get fontSize():uint;
		function get label():String;
		function get mathML():XML;
		function get parent():MathMLContainer;
		function set parent(v:MathMLContainer):void;
		function get resultClass():Class;
		function get toolTipText():String;
		function clone():MathMLElement;
	}
}