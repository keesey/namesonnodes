package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.StateDefinition;

	public final class StateDefinitionReader implements EntityReader
	{
		public function StateDefinitionReader()
		{
			super();
		}
		public function readEntity(source:XML):Persistent
		{
			const def:StateDefinition = new StateDefinition();
			readPersistent(source, def);
			return def;
		}
	}
}