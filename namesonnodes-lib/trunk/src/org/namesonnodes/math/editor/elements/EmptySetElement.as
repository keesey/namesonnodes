package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.events.Event;
	
	public final class EmptySetElement extends AbstractElement implements MathMLElement
	{
		public function EmptySetElement()
		{
			super();
		}
		public function get label():String
		{
			return "Ø";
		}
		public function get mathML():XML
		{
			return <emptyset xmlns={MathML.NAMESPACE.uri}/>;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Empty Set: the set with no members.";
		}
		public function clone():MathMLElement
		{
			return new EmptySetElement();
		}
	}
}