package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.Entities;

	internal final class DefinitionReader implements EntityReader
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
			if (source.children().length() == 0)
				throw new ArgumentError("No definition specified.");
			if (source.children().length() != 1)
				throw new ArgumentError("More than one definition specified.");
			const defSource:XML = source.children()[0];
			if (defSource.name().uri != Entities.URI)
				throw new ArgumentError("Unrecognized namespace: <" + defSource.name().uri + ">.");
			const reader:EntityReader = readers[defSource.localName()] as EntityReader;
			if (reader == null)
				throw new ArgumentError("Unrecognized element: <" + defSource.name() + ">.");
			return reader.readEntity(defSource);
		}
	}
}