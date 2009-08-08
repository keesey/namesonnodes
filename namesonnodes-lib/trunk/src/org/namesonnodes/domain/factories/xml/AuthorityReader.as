package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Authority;

	internal final class AuthorityReader implements EntityReader
	{
		public function AuthorityReader()
		{
			super();
		}
		public function readEntity(source:XML):Persistent
		{
			const authority:Authority = new Authority();
			readPersistent(source, authority);
			readLabelled(source, authority);
			return authority;
		}
	}
}