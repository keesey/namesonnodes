package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.Entities;

	public final class DefinitionReader implements EntityReader
	{
		private const readers:Dictionary = new Dictionary();
		public function DefinitionReader(factory:EntityFactory, taxonIdentifierReader:EntityReader)
		{
			super();
			readers["PhyloDefinition"] = new PhyloDefinitionReader(factory, taxonIdentifierReader);
			readers["RankDefinition"] = new RankDefinitionReader(factory, taxonIdentifierReader);
			readers["SpecimenDefinition"] = new SpecimenDefinitionReader();
			readers["StateDefinition"] = new StateDefinitionReader();
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			if (source.name().uri != Entities.URI)
				throw new ArgumentError("Unrecognized namespace: <" + source.name().uri + ">.");
			const reader:EntityReader = readers[source.localName()] as EntityReader;
			if (reader == null)
				throw new ArgumentError("Unrecognized element: <" + source.name() + ">.");
			return reader.readEntity(source);
		}
	}
}