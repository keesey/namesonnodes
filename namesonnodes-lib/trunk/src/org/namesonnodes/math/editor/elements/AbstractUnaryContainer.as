package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class AbstractUnaryContainer extends AbstractContainer
	{
		private var _child:MathMLElement;
		public function AbstractUnaryContainer()
		{
			super();
			_child = createMissing();
			_child.parent = this as MathMLContainer;
			_child.addEventListener(Event.CHANGE, dispatchEvent);
		}
		public final function get canIncrementChildren():Boolean
		{
			return false;
		}
		protected function get cloneBase():MathMLContainer
		{
			throw new AbstractMethodError();
		}
		public final function get numChildren():uint
		{
			return 1;
		}
		protected function createMissing():MissingElement
		{
			throw new AbstractMethodError();
		}
		public final function clone():MathMLElement
		{
			const c:MathMLContainer = cloneBase;
			c.setChildAt(_child.clone(), 0);
			return c;
		}
		public final function getChildAt(i:uint):MathMLElement
		{
			if (i == 0)
				return _child;
			throw new RangeError();
		}
		public final function getChildIndex(child:MathMLElement):int
		{
			return _child == child ? 0 : -1;
		}
		public final function hasChild(child:MathMLElement):Boolean
		{
			return _child == child;
		}
		public final function incrementChildren():void
		{
			throw new IllegalOperationError();
		}
		public final function removeChild(child:MathMLElement):void
		{
			if (_child == child)
				setChildAt(createMissing(), 0);
		}
		public final function setChildAt(child:MathMLElement, i:uint):void
		{
			if (i != 0)
				throw new RangeError();
			if (!MathMLContainer(this).acceptChildAt(child, 0))
				throw new ArgumentError();
			_child.parent = null;
			_child.removeEventListener(Event.CHANGE, dispatchEvent);
			_child = child;
			_child.addEventListener(Event.CHANGE, dispatchEvent);
			_child.parent = this as MathMLContainer;
			dispatchEvent(new Event(Event.CHANGE));
		}
		public final function toVector():Vector.<MathMLElement>
		{
			return Vector.<MathMLElement>([_child]);
		}
	}
}