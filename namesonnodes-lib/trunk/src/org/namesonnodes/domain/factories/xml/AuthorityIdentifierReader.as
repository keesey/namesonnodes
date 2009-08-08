package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Authority;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Entities;

	internal final class AuthorityIdentifierReader implements EntityReader
	{
		private var entityReader:EntityReader = new AuthorityReader();
		private var factory:EntityFactory;
		public function AuthorityIdentifierReader(factory:EntityFactory)
		{
			super();
			this.factory = factory;
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const identifier:AuthorityIdentifier = new AuthorityIdentifier();
			readPersistent(source, identifier);
			identifier.uri = source.uri;
			if (source.entity.length() != 1)
				throw new ArgumentError("No entity specified.");
			if (source.entity.refAuthority.length() == 1)
				factory.references.push(new AuthorityReference(source.entity.refAuthority.text(), identifier, "entity", true));
			else if (source.entity.Authority.length() == 1)
				identifier.entity = entityReader.readEntity(source.entity.Authority) as Authority;
			else
				throw new ArgumentError("No authority specified or referenced.");
			factory.dictionary[identifier.uri] = identifier;
			return identifier;
		}
	}
}