package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class SuccessorIntersectionElement extends AbstractUnaryContainer implements MathMLContainer
	{
		public function SuccessorIntersectionElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new SuccessorIntersectionElement();
		}
		public function get label():String
		{
			return "suc\n\u2229";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-SuccessorIntersection"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Successor Intersection: yields the set of all common (shared) successors of the members of a taxon.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && i == 0 && child.resultClass == Set;
		}
		override protected function createMissing():MissingElement
		{
			return new MissingElement(Set);
		}
	}
}