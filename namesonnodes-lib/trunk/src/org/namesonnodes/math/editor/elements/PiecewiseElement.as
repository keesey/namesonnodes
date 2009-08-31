package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.events.Event;
	
	public final class PiecewiseElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function PiecewiseElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new PiecewiseElement();
		}
		public function get label():String
		{
			return "{";
		}
		public function get mathML():XML
		{
			default xml namespace = MathML.NAMESPACE.uri;
			var missing:Vector.<MathMLElement>;
			const m:XML = <piecewise/>;
			const n:uint = numChildren - 1;
			for (var i:uint = 0; i < n; ++i)
			{
				try
				{
					m.appendChild(getChildAt(i).mathML);
				}
				catch (e:MissingElementError)
				{
					missing = missing ? missing.concat(e.elements) : e.elements;
				}
			}
			const otherwise:XML = <otherwise/>;
			try
			{
				otherwise.appendChild(getChildAt(n).mathML);
			}
			catch (e:MissingElementError)
			{
				missing = missing ? missing.concat(e.elements) : e.elements;
			}
			if (missing != null && missing.length != 0)
				throw new MissingElementError(missing);
			m.appendChild(otherwise);
			return m;
		}
		public function get resultClass():Class
		{
			const childClasses:MutableSet = new HashSet();
			const n:uint = numChildren;
			for (var i:uint = 0; i < n; ++i)
			{
				const childClass:Class = getChildAt(i).resultClass;
				if (childClass == Object)
					return Object;
				childClasses.add(childClass);
			}
			// :KLUDGE: A better way would be to find the least common ancestor of all types, but this is easier and sufficient for present purposes.
			if (childClasses.size == 1)
				return childClasses.singleMember as Class;
			return Object;
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			if (i > numChildren || child == null)
				return false;
			if (i == numChildren - 1)
				return child.resultClass != null;
			return child is PieceElement;
		}
		public function get toolTipText():String
		{
			return "Piecewise Expression: yields the first contained piece whose conditional is true, or the final contained expression (\"otherwise\") if none are true.";
		}
		public function incrementChildren():void
		{
			insertChild(new PieceElement(), numChildren - 1);
		}
		override public function removeChild(child:MathMLElement):void
		{
			super.removeChild(child);
			if (getChildAt(numChildren - 1) is PieceElement)
				insertChild(new MissingElement(Object), numChildren);
			while (numChildren < 2)
				incrementChildren();
		}
	}
}