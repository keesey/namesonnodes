package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class UnionElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function UnionElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new UnionElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new MissingElement(Set));
			c.push(new MissingElement(Set));
			return c;
		}
		public function get label():String
		{
			return "\u222A";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><union xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Union: yields the union of two or more sets.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && child.resultClass == Set && i <= numChildren;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Set), numChildren);
		}
		override protected function maintainMinimumChildren():void
		{
			while (numChildren < 2)
				incrementChildren();
		}
	}
}