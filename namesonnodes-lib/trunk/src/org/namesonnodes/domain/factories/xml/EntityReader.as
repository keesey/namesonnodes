package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;

	internal interface EntityReader
	{
		function readEntity(source:XML):Persistent;
	}
}