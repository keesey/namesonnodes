package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.entities.labelTaxonIdentifier;
	
	public final class TaxonIdentifierElement extends AbstractElement implements MathMLElement
	{
		private var identifier:TaxonIdentifier;
		public function TaxonIdentifierElement(identifier:TaxonIdentifier)
		{
			super();
			this.identifier = identifier;
		}
		public function get label():String
		{
			return labelTaxonIdentifier(identifier, true);
		}
		public function get mathML():XML
		{
			return <csymbol xmlns={MathML.NAMESPACE.uri} definitionURL={identifier.qName}/>;
		}
		public function get resultClass():Class
		{
			return Set;
		}
		public function get toolTipText():String
		{
			return identifier.label.name + "\n(" + identifier.authority.entity.label.name + ")";
		}
		public function clone():MathMLElement
		{
			return new TaxonIdentifierElement(identifier);
		}
	}
}