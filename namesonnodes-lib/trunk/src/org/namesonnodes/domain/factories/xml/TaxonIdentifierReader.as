package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.entities.non_entities;
	import org.namesonnodes.utils.parseQName;

	use namespace non_entities;

	internal final class TaxonIdentifierReader implements EntityReader
	{
		private var authorityIdentifierReader:EntityReader;
		private var entityReader:EntityReader;
		private var factory:EntityFactory;
		public function TaxonIdentifierReader(factory:EntityFactory, authorityIdentifierReader:EntityReader)
		{
			super();
			this.factory = factory;
			this.authorityIdentifierReader = authorityIdentifierReader;
			entityReader = new TaxonReader(factory, entityReader);
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const identifier:TaxonIdentifier = new TaxonIdentifier();
			readPersistent(source, identifier);
			readQualified(source, identifier, factory.dictionary,
				factory.authorityReferences, authorityIdentifierReader);
			if (source.entity.length() != 1)
				identifier.entity = new Taxon();
			else if (source.entity.refTaxon.length() == 1)
				factory.taxonReferences.push(new TaxonReference(parseQName(source.entity.refTaxon[0].text()), identifier, "entity", true));
			else if (source.entity.Taxon.length() == 1)
				identifier.entity = entityReader.readEntity(source.entity.Taxon[0]) as Taxon;
			else
				throw new ArgumentError("Invalid taxon specification.");
			return identifier;
		}
	}
}