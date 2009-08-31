package org.namesonnodes.math.editor.elements
{
	import flash.events.IEventDispatcher;

	public interface MathMLContainer extends IEventDispatcher, MathMLElement
	{
		function get canIncrementChildren():Boolean;
		function get numChildren():uint;
		function acceptChildAt(child:MathMLElement, i:uint):Boolean;
		function getChildAt(i:uint):MathMLElement;
		function getChildIndex(child:MathMLElement):int;
		function hasChild(child:MathMLElement):Boolean;
		function incrementChildren():void;
		function removeChild(child:MathMLElement):void;
		function setChildAt(child:MathMLElement, i:uint):void;
		function toVector():Vector.<MathMLElement>;
	}
}