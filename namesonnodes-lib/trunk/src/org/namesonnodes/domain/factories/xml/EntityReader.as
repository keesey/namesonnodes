package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;

	public interface EntityReader
	{
		function readEntity(source:XML):Persistent;
	}
}