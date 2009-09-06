package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	public final class TrueElement extends AbstractElement implements MathMLElement
	{
		public function TrueElement()
		{
			super();
		}
		public function get label():String
		{
			return "T";
		}
		public function get mathML():XML
		{
			return <true xmlns={MathML.NAMESPACE.uri}/>;
		}
		public function get resultClass():Class
		{
			return Boolean;
		}
		public function get toolTipText():String
		{
			return "True: positive logical value.";
		}
		public function clone():MathMLElement
		{
			return new TrueElement();
		}
	}
}