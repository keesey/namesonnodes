package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class XOrElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function XOrElement()
		{
			super();
		}
		public function get label():String
		{
			return "xor";
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new XOrElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>(2);
			c[0] = new MissingElement(Boolean);
			c[1] = new MissingElement(Boolean);
			return c;
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><xor xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Exclusive Disjunction: yields true if and only if the two arguments are unequal.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return (i == 0 || i == 1) && child != null && child.resultClass == Boolean;
		}
		override protected function createMissing(index:uint) : MissingElement
		{
			return new MissingElement(Boolean);
		}
	}
}