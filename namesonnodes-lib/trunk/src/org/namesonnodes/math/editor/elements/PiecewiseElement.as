package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class PiecewiseElement extends AbstractNAryContainer implements MathMLContainer
	{
		private var _type:Class = Object;
		public function PiecewiseElement(type:Class)
		{
			super();
			_type = type;
			setChildAt(new PieceElement(type), 0);
			setChildAt(new MissingElement(type), 1);
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new PiecewiseElement(_type);
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new PieceElement(Object));
			c.push(new MissingElement(Object));
			return c;
		}
		public function get label():String
		{
			return "{";
		}
		public function get mathML():XML
		{
			var missing:Vector.<MathMLElement>;
			const m:XML = <piecewise xmlns={MathML.NAMESPACE.uri}/>;
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
			const otherwise:XML = <otherwise xmlns={MathML.NAMESPACE.uri}/>;
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
			return _type;
			/*
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
			*/
		}
		public function get toolTipText():String
		{
			return "Piecewise Expression: yields the first contained piece whose conditional is true, or the final contained expression (\"otherwise\") if none are true.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			if (i > numChildren || child == null)
				return false;
			if (i == numChildren - 1)
				return child.resultClass == _type;
			return child is PieceElement && PieceElement(child).type == _type;
		}
		override public function getChildLabelAt(i:uint) : String
		{
			if (i == numChildren - 1)
				return "otherwise";
			return String(i + 1);
		}
		public function incrementChildren():void
		{
			insertChild(new PieceElement(_type), numChildren - 1);
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