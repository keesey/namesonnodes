package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Definition;
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.non_entities;

	use namespace non_entities;

	internal final class TaxonReader implements EntityReader
	{
		private var definitionReader:EntityReader;
		public function TaxonReader(factory:EntityFactory, taxonIdentifierReader:EntityReader)
		{
			super();
			definitionReader = new DefinitionReader(factory, taxonIdentifierReader);
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const taxon:Taxon = new Taxon();
			readPersistent(source, taxon);
			if (source.definition.length() == 1)
				taxon.definition = definitionReader.readEntity(source.definition[0]) as Definition;
			return taxon;
		}
	}
}