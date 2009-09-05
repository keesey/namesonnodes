package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	
	import org.namesonnodes.math.entities.Taxon;
	
	internal function toTaxon(arg:*):Set
	{
		const s:Set = arg as Set;
		if (s.empty)
			return EmptySet.INSTANCE;
		if (!(s is Taxon))
			throw new MathMLError("Expected taxon or empty set; found: " + arg);
		return s;
	}
}