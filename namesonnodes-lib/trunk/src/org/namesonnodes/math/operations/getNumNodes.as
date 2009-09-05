package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	
	import org.namesonnodes.math.entities.Taxon;

	internal function getNumNodes(s:Set):uint
	{
		return s.empty ? 0 : Taxon(s).numNodes;
	}
}