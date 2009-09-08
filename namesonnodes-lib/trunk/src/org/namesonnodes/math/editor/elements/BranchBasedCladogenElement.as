package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class BranchBasedCladogenElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function BranchBasedCladogenElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new BranchBasedCladogenElement();
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
			return "\u2190";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-BranchBasedCladogen"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Branch-Based Cladogen: yields the minimal predecessors of an internal taxon,\n" + 
					"exclusive of all predecessors of an external taxon.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && (i == 0 || i == 1) && child.resultClass == Set;
		}
		override protected function createMissing(index:uint):MissingElement
		{
			return new MissingElement(Set);
		}
		override public function getChildLabelAt(i:uint):String
		{
			return i == 0 ? "in" : "ex";
		}
	}
}