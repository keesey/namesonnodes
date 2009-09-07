package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class ApomorphyBasedCladeElement extends AbstractBinaryContainer implements MathMLContainer
	{
		public function ApomorphyBasedCladeElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new ApomorphyBasedCladeElement();
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
			return "Clade\nin";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-ApomorphyBasedClade"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Apomorphy-Based Clade: yields all successors of the minimal predecessors of a representative taxon (R) which share membership " + 
					"in an apomorphic taxon (A) synapomorphically (homologously) with the members of the representative taxon.";
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
			return i == 0 ? "A" : "R";
		}
	}
}