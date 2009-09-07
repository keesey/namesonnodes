package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class ImpliesElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function ImpliesElement()
		{
			super();
		}
		public function get label():String
		{
			return "\u21D2";
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new ImpliesElement();
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
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><implies xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Implication: yields the logical entailment of an antecedent (A) and a consequent (C).";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return (i == 0 || i == 1) && child != null && child.resultClass == Boolean;
		}
		override protected function createMissing(index:uint) : MissingElement
		{
			return new MissingElement(Boolean);
		}
		override public function getChildLabelAt(i:uint) : String
		{
			if (i == 0)
				return "A";
			if (i == 1)
				return "C";
			return "";
		}
	}
}