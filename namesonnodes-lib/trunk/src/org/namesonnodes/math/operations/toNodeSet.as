package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	
	import org.namesonnodes.math.entities.Taxon;

	internal function toNodeSet(s:Set):FiniteSet
	{
		if (s.empty)
			return EmptySet.INSTANCE;
		return Taxon(s).toNodeSet();
	}
}