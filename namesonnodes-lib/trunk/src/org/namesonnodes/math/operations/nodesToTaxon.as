package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	
	import org.namesonnodes.math.entities.Taxon;

	internal function nodesToTaxon(nodes:FiniteSet):Set
	{
		if (nodes.empty)
			return EmptySet.INSTANCE;
		return Taxon.fromFinestNodes(nodes);
	}
}