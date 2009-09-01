package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class EqElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function EqElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new EqElement();
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
			return "=";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><eq xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Equality: checks if two or more elements are equivalent.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && child.resultClass != null && i < numChildren;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Object), numChildren);
		}
		override public function removeChild(child:MathMLElement):void
		{
			super.removeChild(child);
			while (numChildren < 2)
				incrementChildren();
		}
	}
}