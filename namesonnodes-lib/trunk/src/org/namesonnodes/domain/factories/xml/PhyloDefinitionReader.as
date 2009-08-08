package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	import a3lbmonkeybrain.brainstem.w3c.xhtml.XHTML;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.PhyloDefinition;
	import org.namesonnodes.domain.entities.non_entities;
	import org.namesonnodes.utils.parseQName;

	use namespace non_entities;

	internal final class PhyloDefinitionReader implements EntityReader
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
			if (source.formula.length() == 0)
				throw new ArgumentError("No formula in phylogeny-based definition.");
			if (source.formula.length() != 1)
				throw new ArgumentError("Too many formulas in phylogeny-based definition.");
			if (source.formula[0].children().length() != 1)
				throw new ArgumentError("Invalid formula in phylogeny-based definition.");
			if (source.formula[0].children()[0].name() != MathML.MATH)
				throw new ArgumentError("Expected <" + MathML.MATH + "> element; found <" + def.formula[0].children()[0].name() + ">.");
			if (source.prose.length() == 0)
				throw new ArgumentError("No prose in phylogeny-based definition.");
			if (source.prose.length() != 1)
				throw new ArgumentError("Too many prose entries in phylogeny-based definition.");
			if (source.prose[0].children().length() != 1)
				throw new ArgumentError("Invalid formula in phylogeny-based definition.");
			if (source.prose[0].children()[0].name() != new QName(XHTML.NAMESPACE, "div"))
				throw new ArgumentError("Expected <" + XHTML.NAMESPACE + "::div> element; found <" + def.prose[0].children()[0].name() + ">.");
			def.formula = source.formula.children()[0] as XML;
			def.prose = source.prose.children()[0] as XML;
			for each (var specifierSource:XML in source.specifiers.children())
			{
				if (specifierSource.name().uri != Entities.URI)
					throw new ArgumentError("Unrecognized namespace: " + specifierSource.name().uri);
				if (specifierSource.localName() == "TaxonIdentifier")
					def.specifiers.addItem(taxonIdentifierReader.readEntity(specifierSource));
				else if (specifierSource.localName() == "refTaxon")
				{
					factory.taxonReferences.push(new TaxonReference(parseQName(specifierSource.text()),
						def.specifiers, def.specifiers.length));
					def.specifiers.addItem(null);
				}
				else
					throw new ArgumentError("Unrecognized element: <" + specifierSource.name() + ">.");
			}
			return def;
		}
	}
}