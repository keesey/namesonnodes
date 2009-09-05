package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	
	import org.namesonnodes.math.entities.Taxon;

	internal function toNodeArray(s:Set):Array
	{
		if (s.empty)
			return [];
		return Taxon(s).toNodeSet().toArray();
	}
}