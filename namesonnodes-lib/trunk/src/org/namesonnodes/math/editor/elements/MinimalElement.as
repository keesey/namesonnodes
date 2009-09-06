package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class MinimalElement extends AbstractUnaryContainer implements MathMLContainer
	{
		public function MinimalElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new MinimalElement();
		}
		public function get label():String
		{
			return "min";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-Minimal"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Minimal: yields the set of all members of a taxon which have no descendants in that taxon.";
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