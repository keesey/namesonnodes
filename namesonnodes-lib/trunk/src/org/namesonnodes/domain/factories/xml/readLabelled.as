package org.namesonnodes.domain.factories.xml
{
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Labelled;

	internal function readLabelled(source:XML, entity:Labelled):void
	{
		default xml namespace = Entities.URI;
		const labelSource:XML = source.label.Label;
		if (labelSource == null)
			throw new ArgumentError("No label in XML source.");
		if (labelSource.name.length() != 1)
			throw new ArgumentError("No name in label.");
		entity.label.name = labelSource.name;
		entity.label.abbr = labelSource.abbr;
		entity.label.italics = labelSource.italics == "true";
	}
}