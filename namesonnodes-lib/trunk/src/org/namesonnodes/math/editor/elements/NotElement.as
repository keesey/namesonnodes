package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.errors.IllegalOperationError;

	public final class NotElement extends AbstractUnaryContainer implements MathMLContainer
	{
		public function NotElement()
		{
			super();
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new NotElement();
		}
		public function get label() : String
		{
			return "not";
		}
		public function get mathML() : XML
		{
			default xml namespace = MathML.NAMESPACE.uri;
			const m:XML = <apply><not/></apply>;
			appendChildrenMathML(m);
			return m;
		}
		public function get resultClass() : Class
		{
			return Boolean;
		}
		public function get toolTipText() : String
		{
			return "Negation: returns the logical negation (\"not\") of a Boolean value.";
		}
		override protected function createMissing() : MissingElement
		{
			return new MissingElement(Boolean);
		}
		public function acceptChildAt(child:MathMLElement, i:uint) : Boolean
		{
			return child != null && child.resultClass == Boolean && i == 0;
		}
		public function incrementChildren() : void
		{
			throw new IllegalOperationError();
		}
	}
}