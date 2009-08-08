package org.namesonnodes.domain.factories.xml
{
	import org.namesonnodes.domain.entities.AbstractQualified;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Entities;

	internal function readQualified(source:XML, entity:AbstractQualified, references:Vector.<IdentifierReference>, authorityIdentifierReader:EntityReader):void
	{
		readLabelled(source, entity);
		default xml namespace = Entities.URI;
		if (source.authority.length() != 1)
			throw new ArgumentError("No authority specified.");
		if (source.localName.length() != 1)
			throw new ArgumentError("No local name specified.");
		entity.localName = source.localName;
		if (source.authority.refAuthority.length() == 1)
			references.push(new AuthorityReference(source.entity.refAuthority.text(), entity, "authority"));
		else if (source.authority.AuthorityIdentifier.length() == 1)
			entity.authority = authorityIdentifierReader.readEntity(source.entity.AuthorityIdentifier) as AuthorityIdentifier;
		else
			throw new ArgumentError("No authority identified or referenced.");
	}
}