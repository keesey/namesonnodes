package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.events.Event;
	
	public final class UniversalTaxonElement extends AbstractElement implements MathMLElement
	{
		public function UniversalTaxonElement()
		{
			super();
		}
		public function get label():String
		{
			return "U";
		}
		public function get mathML():XML
		{
			return <csymbol xmlns={MathML.NAMESPACE.uri} definitionURL="http://namesonnodes.org/ns/math/2009#def-UniversalTaxon"/>;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return "Universal Taxon: the set of all organisms.";
		}
		public function clone():MathMLElement
		{
			return new UniversalTaxonElement();
		}
	}
}