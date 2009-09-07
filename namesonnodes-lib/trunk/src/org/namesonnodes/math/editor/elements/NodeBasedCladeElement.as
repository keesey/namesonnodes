package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class NodeBasedCladeElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function NodeBasedCladeElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new NodeBasedCladeElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new MissingElement(Set));
			return c;
		}
		public function get label():String
		{
			return "Clade\n+";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-NodeBasedClade"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Node-Based Clade: all successors of the maximal common predecessors of a set of organisms.\nAccepts one or more arguments.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && i < numChildren && child.resultClass == Set;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Set), numChildren);
		}
		override protected function maintainMinimumChildren():void
		{
			if (numChildren == 0)
				incrementChildren();
		}
	}
}