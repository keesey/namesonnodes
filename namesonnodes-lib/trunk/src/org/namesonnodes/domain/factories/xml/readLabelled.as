package org.namesonnodes.domain.factories.xml
{
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Labelled;
	import org.namesonnodes.domain.entities.non_entities;

	use namespace non_entities;

	internal function readLabelled(source:XML, entity:Labelled):void
	{
		if (source == null || source.label.length() == 0)
			return;
		if (source.label.length() != 1)
			throw new ArgumentError("Invalid label.");
		if (source.label.Label.length() != 1)
			throw new ArgumentError("Invalid label.");
		default xml namespace = Entities.URI;
		const labelSource:XML = source.label.Label[0] as XML;
		if (labelSource == null)
			throw new ArgumentError("No label in XML source.");
		if (labelSource.name.length() != 1)
			throw new ArgumentError("No name in label.");
		entity.label.name = labelSource.name;
		entity.label.abbr = labelSource.abbr;
		entity.label.italics = labelSource.italics == "true";
	}
}