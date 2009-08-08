package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.non_entities;

	use namespace non_entities;

	internal function readPersistent(source:XML, entity:Persistent):void
	{
		default xml namespace = Entities.URI;
		if (source.@id)
			entity.id = parseInt(source.@id);
		if (source.@version)
			entity.version = parseInt(source.@version);
	}
}