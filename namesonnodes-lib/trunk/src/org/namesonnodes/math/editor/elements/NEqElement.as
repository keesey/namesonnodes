package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class NEqElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function NEqElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new NEqElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			const c:Vector.<MathMLElement> = new Vector.<MathMLElement>();
			c.push(new MissingElement(Object));
			c.push(new MissingElement(Object));
			return c;
		}
		public function get label():String
		{
			return "\u2260";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><neq xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Inequality: checks if two or more elements are not equivalent.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && child.resultClass != null && i < numChildren;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Object), numChildren);
		}
		override protected function maintainMinimumChildren():void
		{
			while (numChildren < 2)
				incrementChildren();
		}
	}
}