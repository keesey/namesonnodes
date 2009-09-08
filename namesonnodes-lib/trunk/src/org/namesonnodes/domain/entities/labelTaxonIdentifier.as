package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;

	public function labelTaxonIdentifier(identifier:TaxonIdentifier,
		useHTML:Boolean = false, lineBreak:String = "\n"):String
	{
		if (identifier == null)
			return "[no identifier]";
		if (identifier.entity == null)
			return "[no taxon]";
		const def:Definition = identifier.entity.definition;
		var name:String = (def is RankDefinition || def is PhyloDefinition) ? identifier.label.name.replace(/\s+/, lineBreak) : identifier.label.abbrOrName;
		if (!isNonEmptyString(name))
			name = unescape(identifier.localName);
		var useAuthName:Boolean = false;
		if (!isNonEmptyString(name))
		{
			name = "[no name]";
			useAuthName = true;
		} 
		if (!useAuthName && (def == null || def is SpecimenDefinition))
			useAuthName = true;
		if (useHTML && identifier.label.italics)
			name = "<i>" + name + "</i>";
		if (useAuthName)
		{
			var authName:String;
			if (identifier.authority == null)
				authName = "[no authority identifier]";
			else if (identifier.authority.entity == null)
				authName = "[no authority]";
			else
			{
				authName = identifier.authority.entity.label.abbrOrName;
				if (!isNonEmptyString(authName))
					authName = "[unnamed authority]";
				if (useHTML && identifier.authority.entity.label.italics)
					authName = "<i>" + authName + "</i>";
			}
			if (def is SpecimenDefinition)
				return authName + lineBreak + name;
			return name + lineBreak + "(" + authName + ")";
		}
		return name;
	}
}