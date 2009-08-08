package org.namesonnodes.domain.factories.xml
{
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.AbstractQualified;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.non_entities;

	use namespace non_entities;

	internal function readQualified(source:XML, entity:AbstractQualified,
		qNameDictionary:Dictionary, references:Vector.<AuthorityReference>,
		authorityIdentifierReader:EntityReader):void
	{
		default xml namespace = Entities.URI;
		readLabelled(source, entity);
		if (source.authority.length() != 1)
			throw new ArgumentError("No authority specified:\n" + source.toXMLString());
		if (source.@localName.length() != 1)
			throw new ArgumentError("No local name specified:\n" + source.toXMLString());
		entity.localName = source.@localName;
		if (source.authority.refAuthority.length() == 1)
		{
			const uri:String = source.entity.refAuthority.text();
			if (references != null)
				references.push(new AuthorityReference(uri, entity, "authority"));
			if (qNameDictionary != null)
				qNameDictionary[uri + "::" + entity.localName] = entity;
		}
		else if (source.authority.AuthorityIdentifier.length() == 1)
		{
			entity.authority = authorityIdentifierReader.readEntity(source.entity.AuthorityIdentifier) as AuthorityIdentifier;
			if (qNameDictionary != null)
				qNameDictionary[entity.qName.toString()] = entity;
		}
		else
			throw new ArgumentError("No authority identified or referenced:\n" + source.authority.toXMLString());
	}
}