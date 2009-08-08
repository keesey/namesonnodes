package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.SpecimenDefinition;

	internal final class SpecimenDefinitionReader implements EntityReader
	{
		public function SpecimenDefinitionReader()
		{
			super();
		}
		public function readEntity(source:XML):Persistent
		{
			const def:SpecimenDefinition = new SpecimenDefinition();
			readPersistent(source, def);
			return def;
		}
	}
}