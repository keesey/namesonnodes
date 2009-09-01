package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class PieceElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function PieceElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new PieceElement();
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
			return getChildAt(0).resultClass;
		}
		public function get toolTipText():String
		{
			return "Piece: a piece of a piecewise expression, consisting of a value and a conditional test.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			if (child == null)
				return false;
			if (i == 0)
				return child.resultClass != null;
			if (i == 1)
				return child.resultClass == Boolean;
			return false;
		}
	}
}