package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	import a3lbmonkeybrain.brainstem.w3c.xhtml.XHTML;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.PhyloDefinition;
	import org.namesonnodes.utils.parseQName;

	public final class PhyloDefinitionReader implements EntityReader
	{
		private var factory:EntityFactory;
		private var taxonIdentifierReader:EntityReader;
		public function PhyloDefinitionReader(factory:EntityFactory, taxonIdentifierReader:EntityReader)
		{
			super();
			this.factory = factory;
			this.taxonIdentifierReader = taxonIdentifierReader;
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const def:PhyloDefinition = new PhyloDefinition();
			readPersistent(source, def);
			def.formula = source.formula.children()[0] as XML;
			if (def.formula == null)
				throw new ArgumentError("No formula in phylogeny-based definition.");
			if (def.formula.name() != MathML.MATH)
				throw new ArgumentError("Expected <" + MathML.MATH + "> element; found <" + def.formula.name() + ">.");
			def.prose = source.prose.children()[0] as XML;
			if (def.prose == null)
				throw new ArgumentError("No prose in phylogeny-based definition.");
			if (def.prose.name() != new QName(XHTML.NAMESPACE, "div"))
				throw new ArgumentError("Expected <" + XHTML.NAMESPACE + "::div> element; found <" + def.prose.name() + ">.");
			for each (var specifierSource:XML in source.specifiers)
			{
				if (specifierSource.name().uri != Entities.URI)
					throw new ArgumentError("Unrecognized namespace: " + specifierSource.name().uri);
				if (specifierSource.localName() == "TaxonIdentifier")
					def.specifiers.addItem(taxonIdentifierReader.readEntity(specifierSource));
				else if (specifierSource.localName() == "refTaxon")
				{
					factory.references.push(new TaxonReference(parseQName(specifierSource.text()),
						def.specifiers, String(def.specifiers.length)));
					def.specifiers.addItem(null);
				}
				else
					throw new ArgumentError("Unrecognized element: <" + specifierSource.name() + ">.");
			}
			return def;
		}
	}
}