package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class MathElement extends AbstractNAryContainer implements MathMLContainer
	{
		public function MathElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new MathElement();
		}
		override protected function get initialChildren() : Vector.<MathMLElement>
		{
			return new Vector.<MathMLElement>();
		}
		public function get label():String
		{
			return "math";
		}
		public function get mathML():XML
		{
			const m:XML = <math xmlns={MathML.NAMESPACE.uri}/>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass():Class
		{
			return null;
		}
		public function get toolTipText():String
		{
			return "Mathematics: a collection of expressions.";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			if (i >= numChildren)
				return false;
			if (child is DeclareElement)
			{
				const n:uint = numChildren;
				for (var i:uint = 0; i < n; ++i)
				{
					var otherChild:MathMLElement = getChildAt(i);
					if (otherChild is DeclareElement && DeclareElement(otherChild).identifier == DeclareElement(child).identifier)
						return false;
				}
			}
			return child != null;
		}
		public function incrementChildren():void
		{
			insertChild(new MissingElement(Object), 0);
		}
	}
}