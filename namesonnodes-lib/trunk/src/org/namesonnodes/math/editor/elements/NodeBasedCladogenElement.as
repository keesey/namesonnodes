package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class NodeBasedCladogenElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function NodeBasedCladogenElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new NodeBasedCladogenElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new MissingElement(Set));
			return c;
		}
		public function get label():String
		{
			return "+";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-NodeBasedCladogen"/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Node-Based Cladogen: the maximal common predecessors of a set of organisms.\nAccepts one or more arguments.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && i < numChildren && child.resultClass == Set;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Set), numChildren);
		}
		override public function removeChild(child:MathMLElement) : void
		{
			super.removeChild(child);
			if (numChildren == 0)
				incrementChildren();
		}
	}
}