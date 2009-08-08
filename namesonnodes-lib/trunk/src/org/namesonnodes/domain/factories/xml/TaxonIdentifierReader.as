package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

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
			readQualified(source, identifier, factory.references, authorityIdentifierReader);
			if (source.entity.length() != 1)
				throw new ArgumentError("No entity specified.");
			if (source.entity.refTaxon.length() == 1)
				factory.references.push(new TaxonReference(source.entity.refTaxon.text(), identifier, "entity", true));
			else if (source.entity.Taxon.length() == 1)
				identifier.entity = entityReader.readEntity(source.entity.Taxon) as Taxon;
			else
				throw new ArgumentError("No taxon specified or referenced.");
			factory.dictionary[identifier.qName.toString()] = identifier;
			return identifier;
		}
	}
}