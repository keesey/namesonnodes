package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class AbstractBinaryContainer extends AbstractContainer
	{
		private var _children:Vector.<MathMLElement> = initialChildren;
		public function AbstractBinaryContainer()
		{
			super();
			for each (var child:MathMLElement in _children)
				child.addEventListener(Event.CHANGE, dispatchEvent);
		}
		protected function get cloneBase():MathMLContainer
		{
			throw new AbstractMethodError();
		}
		public final function get canIncrementChildren():Boolean
		{
			return false;
		}
		protected function get initialChildren():Vector.<MathMLElement>
		{
			throw new AbstractMethodError();
		}
		public final function get numChildren():uint
		{
			return 2;
		}
		public final function clone():MathMLElement
		{
			const c:MathMLContainer = cloneBase;
			c.setChildAt(getChildAt(0).clone(), 0);
			c.setChildAt(getChildAt(1).clone(), 1);
			return c;
		}
		protected function createMissing(index:uint):MissingElement
		{
			throw new AbstractMethodError();
		}
		public final function getChildAt(i:uint):MathMLElement
		{
			return _children[i];
		}
		public final function getChildIndex(child:MathMLElement):int
		{
			return _children.indexOf(child);
		}
		public final function hasChild(child:MathMLElement):Boolean
		{
			return _children.indexOf(child) >= 0;
		}
		public final function incrementChildren():void
		{
			throw new IllegalOperationError();
		}
		public final function removeChild(child:MathMLElement):void
		{
			const i:int = _children.indexOf(child);
			if (i >= 0)
			{
				const newChild:MathMLElement = _children[i] = createMissing(i);
				newChild.parent = this as MathMLContainer;
				newChild.addEventListener(Event.CHANGE, dispatchEvent);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public final function setChildAt(child:MathMLElement, i:uint):void
		{
			if (i >= 2)
				throw new RangeError();
			if (!MathMLContainer(this).acceptChildAt(child, i))
				throw new ArgumentError();
			const oldChild:MathMLElement = _children[i];
			oldChild.parent = null;
			oldChild.removeEventListener(Event.CHANGE, dispatchEvent);
			_children[i] = child;
			child.addEventListener(Event.CHANGE, dispatchEvent);
			child.parent = this as MathMLContainer;
			dispatchEvent(new Event(Event.CHANGE));
		}
		public final function toVector():Vector.<MathMLElement>
		{
			return _children.concat();
		}
	}
}