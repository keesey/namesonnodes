package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.events.Event;
	
	public class AbstractNAryContainer extends AbstractContainer
	{
		private var _children:Vector.<MathMLElement>;
		public function AbstractNAryContainer()
		{
			super();
			_children = initialChildren;
			for each (var child:MathMLElement in _children)
			{
				child.parent = this as MathMLContainer;
				child.addEventListener(Event.CHANGE, dispatchEvent);
			}
		}
		public final function get canIncrementChildren():Boolean
		{
			return true;
		}
		protected function get cloneBase():MathMLContainer
		{
			throw new AbstractMethodError();
		}
		protected function get initialChildren():Vector.<MathMLElement>
		{
			throw new AbstractMethodError();
		}
		public final function get numChildren():uint
		{
			return _children.length;
		}
		public final function clone():MathMLElement
		{
			const c:MathMLContainer = cloneBase;
			const n:uint = numChildren;
			while (c.numChildren < numChildren)
				MathMLContainer(c).incrementChildren();
			for (var i:uint = 0; i < n; ++i)
				c.setChildAt(getChildAt(i).clone(), i);
			return c;
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
		protected final function insertChild(child:MathMLElement, index:uint):void
		{
			if (child != null && !hasChild(child))
			{
				if (index == numChildren)
					_children.push(child);
				else if (index > numChildren)
					throw new RangeError();
				else
					_children.splice(index, 0, child);
				child.parent = this as MathMLContainer;
				child.addEventListener(Event.CHANGE, dispatchEvent);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		protected function maintainMinimumChildren():void
		{
		}
		public final function removeChild(child:MathMLElement):void
		{
			const i:int = _children.indexOf(child);
			if (i >= 0)
			{
				_children.splice(i, 1);
				child.removeEventListener(Event.CHANGE, dispatchEvent);
				child.parent = null;
				maintainMinimumChildren();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function setChildAt(child:MathMLElement, i:uint):void
		{
			if (i >= numChildren)
				throw new RangeError();
			if (!MathMLContainer(this).acceptChildAt(child, i))
				throw new ArgumentError();
			else if (_children[i] != child)
			{
				const oldChild:MathMLElement = _children[i];
				oldChild.parent = null;
				oldChild.removeEventListener(Event.CHANGE, dispatchEvent);
				_children[i] = child;
				child.parent = this as MathMLContainer;
				child.addEventListener(Event.CHANGE, dispatchEvent);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public final function toVector():Vector.<MathMLElement>
		{
			return _children.concat();
		}
	}
}