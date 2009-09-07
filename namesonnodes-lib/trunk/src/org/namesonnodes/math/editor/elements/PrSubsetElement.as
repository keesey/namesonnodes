package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class PrSubsetElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function PrSubsetElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new PrSubsetElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>(2);
			c[0] = createMissing(0);
			c[1] = createMissing(1);
			return c;
		}
		public function get label():String
		{
			return "\u228A";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><prsubset xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Proper Subset: tells whether a set (sub) is a proper subset of another set (sup).\nDoes not hold true if the sets are equal.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && (i == 0 || i == 1) && child.resultClass == Set;
		}
		override protected function createMissing(index:uint) : MissingElement
		{
			return new MissingElement(Set);
		}
		override public function getChildLabelAt(i:uint):String
		{
			return (i == 0) ? "sub" : "sup";
		}
	}
}