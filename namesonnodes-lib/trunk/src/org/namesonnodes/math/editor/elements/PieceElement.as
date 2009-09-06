package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class PieceElement extends AbstractBinaryContainer implements MathMLContainer, TypedElement
	{
		private var _type:Class;
		public function PieceElement(type:Class)
		{
			super();
			_type = type;
			setChildAt(new MissingElement(type), 0);
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new PieceElement(_type);
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>(2);
			c[0] = new MissingElement(Object);
			c[1] = new MissingElement(Boolean);
			return c;
		}
		public function get label():String
		{
			return "?";
		}
		public function get mathML():XML
		{
			const m:XML = <piece xmlns={MathML.NAMESPACE.uri}/>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return null;
		}
		public function get toolTipText():String
		{
			return "Piece: a piece of a piecewise expression,\n" + 
					"consisting of a value and a conditional test.";
		}
		public function get type():Class
		{
			return _type;
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			if (child == null)
				return false;
			if (i == 0)
				return child.resultClass == _type;
			if (i == 1)
				return child.resultClass == Boolean;
			return false;
		}
		override public function getChildLabelAt(i:uint) : String
		{
			if (i == 0)
				return "value";
			return "condition";
		}
	}
}