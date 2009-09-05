package org.namesonnodes.math.editor.elements
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IVisualElement;

	[Event(name = "change", type = "flash.events.Event")]
	public interface MathMLElement extends IEventDispatcher
	{
		function get graphics():IVisualElement;
		function get label():String;
		function get mathML():XML;
		function get parent():MathMLContainer;
		function set parent(v:MathMLContainer):void;
		function get resultClass():Class;
		function get toolTipText():String;
		function clone():MathMLElement;
	}
}