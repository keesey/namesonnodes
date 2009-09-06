package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class SetDiffElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function SetDiffElement()
		{
			super();
		}
		public function get label():String
		{
			return "−";
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new SetDiffElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>(2);
			c[0] = new MissingElement(Set);
			c[0] = new MissingElement(Set);
			return c;
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><setdiff xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Set Difference: yields the relative complement of two sets (A and B).";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return (i == 0 || i == 1) && child != null && child.resultClass == Set;
		}
		override protected function createMissing(index:uint) : MissingElement
		{
			return new MissingElement(Set);
		}
		override public function getChildLabelAt(i:uint) : String
		{
			if (i == 0)
				return "A";
			if (i == 1)
				return "B";
			return "";
		}
	}
}