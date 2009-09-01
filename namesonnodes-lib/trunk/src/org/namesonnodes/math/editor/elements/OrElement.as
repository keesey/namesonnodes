package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class OrElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function OrElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new OrElement();
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
			return "or";
		}
		public function get mathML():XML
		{
			const m:XML = <apply xmlns={MathML.NAMESPACE.uri}><or xmlns={MathML.NAMESPACE.uri}/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "Disjunction: yields the logical disjunction (\"or\") of two or more Boolean values.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null && child.resultClass == Boolean && i <= numChildren;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Boolean), numChildren);
		}
		override public function removeChild(child:MathMLElement) : void
		{
			super.removeChild(child);
			while (numChildren < 2)
				incrementChildren();
		}
	}
}