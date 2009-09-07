package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class AndElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function AndElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new AndElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new MissingElement(Boolean));
			c.push(new MissingElement(Boolean));
			return c;
		}
		public function get label():String
		{
			return "and";
		}
		public function get mathML():XML
		{
			default xml namespace = MathML.NAMESPACE;
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><and xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Conjunction: yields the logical conjunction (\"and\") of two or more Boolean values.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && child.resultClass == Boolean && i <= numChildren;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Boolean), numChildren);
		}
		override protected function maintainMinimumChildren():void
		{
			while (numChildren < 2)
				incrementChildren();
		}
	}
}