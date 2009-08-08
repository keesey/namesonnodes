package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.RankDefinition;
	import org.namesonnodes.utils.parseQName;

	public final class RankDefinitionReader implements EntityReader
	{
		private var factory:EntityFactory;
		private var taxonIdentifierReader:EntityReader;
		public function RankDefinitionReader(factory:EntityFactory, taxonIdentifierReader:EntityReader)
		{
			super();
			this.factory = factory;
			this.taxonIdentifierReader = taxonIdentifierReader;
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const def:RankDefinition = new RankDefinition();
			readPersistent(source, def);
			def.level = parseInt(source.level);
			def.rank = source.rank;
			for each (var typeSource:XML in source.types)
			{
				if (typeSource.name().uri != Entities.URI)
					throw new ArgumentError("Unrecognized namespace: " + typeSource.name().uri);
				if (typeSource.localName() == "TaxonIdentifier")
					def.types.addItem(taxonIdentifierReader.readEntity(typeSource));
				else if (typeSource.localName() == "refTaxon")
				{
					factory.references.push(new TaxonReference(parseQName(typeSource.text()),
						def.types, String(def.types.length)));
					def.types.addItem(null);
				}
				else
					throw new ArgumentError("Unrecognized element: <" + typeSource.name() + ">.");
			}
			return def;
		}
	}
}