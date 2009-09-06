package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class FalseElement extends AbstractElement implements MathMLElement
	{
		public function FalseElement()
		{
			super();
		}
		public function get label():String
		{
			return "F";
		}
		public function get mathML():XML
		{
			return <false xmlns={MathML.NAMESPACE.uri}/>;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "False: positive logical value.";
		}
		public function clone():MathMLElement
		{
			return new FalseElement();
		}
	}
}