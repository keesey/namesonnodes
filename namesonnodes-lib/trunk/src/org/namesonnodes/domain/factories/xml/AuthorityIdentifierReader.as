package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Authority;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.non_entities;

	use namespace non_entities;
	
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
			identifier.uri = source.@uri;
			if (!isNonEmptyString(identifier.uri))
				throw new ArgumentError("No URI for authority:\n" + source);
			if (source.entity.length() != 1)
				throw new ArgumentError("No entity specified:\n" + source.toXMLString());
			if (source.entity[0].refAuthority.length() == 1)
			{
				const uri:String = source.entity[0].refAuthority[0];
				if (uri == null)
					throw new ArgumentError("No URI for authority: " + source.entity[0]);
				factory.authorityReferences.push(new AuthorityReference(uri, identifier, "entity", true));
			}
			else if (source.entity[0].Authority.length() == 1)
				identifier.entity = entityReader.readEntity(source.entity[0].Authority[0]) as Authority;
			else
				throw new ArgumentError("No authority specified or referenced:\n" + source.toXMLString());
			factory.dictionary[identifier.uri] = identifier;
			return identifier;
		}
	}
}