package org.namesonnodes.commands.biofiles
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.calculia.collections.graphs.DirectedGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.HashNetwork;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class InclusionInference
	{
		private static function addIfBelongs(s:MutableSet, taxon:TaxonIdentifier, childWeights:Dictionary,
			phylogeny:DirectedGraph):Boolean
		{
			if (s.has(taxon))
				return true;
			const weight:Number = childWeights[taxon];
			if (weight > 0.5001)
			{
				s.add(taxon);
				return true;
			}
			if (weight > 0.0001)
			{
				const directPredecessors:MutableSet = phylogeny.directPredecessors(taxon);
				for each (var predecessor:TaxonIdentifier in directPredecessors)
					if (addIfBelongs(s, predecessor, childWeights, phylogeny))
					{
						s.add(taxon);
						return true;
					}
			}
			return false;
		}
		private static function derivePhylogeny(heredities:Object):HashNetwork
		{
			const phylogeny:HashNetwork = new HashNetwork();
			for each (var heredity:Heredity in heredities)
				if (heredity.weight == 0.0)
					phylogeny.createEdge(heredity.predecessor, heredity.successor);
				else
					phylogeny.createEdge(heredity.predecessor, heredity.successor, heredity.weight);
			return phylogeny;
		}
		private static function findChildWeight(taxon:TaxonIdentifier, childWeights:Dictionary,
			phylogeny:DirectedGraph):Number
		{
			const existingWeight:* = childWeights[taxon];
			if (existingWeight is Number)
				return existingWeight;
			const children:MutableSet = phylogeny.directSuccessors(taxon);
			if (children.empty)
			{
				childWeights[identity] = 0.0;
				return 0.0;
			}
			var total:Number = 0.0;
			for (each var child:TaxonIdentifier in children)
				total += findChildWeight(child, childWeights, phylogeny);
			const average:Number = total / children.size;
			childWeights[identity] = average;
			return average;
		}
		public static inferInclusions(scoreMap:Dictionary, heredities:Object):FiniteSet
		{
			// Derive phylogeny.
			const phylogeny:HashNetwork = derivePhylogeny(heredities);
			// Build inferences.
			const inferences:Dictionary = new Dictionary();
			const normalizedInferences:Dictionary = new Dictionary();
			for (var state:* in scoreMap)
			{
				var inferredSet:FiniteSet = inferSet(scoreMap[state] as FiniteSet, phylogeny);
				inferences[state] = normalizedInferences[state] = inferredSet;
			}
			// Normalize to minimize number of inclusions.
			for (var stateA:* in inferences)
			{
				var aSub:FiniteSet = inferences[stateA] as FiniteSet;
				if (!aSub.empty)
					for (var stateB:* in inferences)
						if (stateA != stateB)
						{
							var bSub:FiniteSet = inferences[stateB] as FiniteSet;
							if (!bSub.empty && bSub.prSubsetOf(aSub))
								// Proper superset found; normalize inferred
								// subsets.
								normalizedInferences[stateA] = FiniteSet(normalizedInferences[stateA]).diff(bSub);
						}
			}
			// Convert inferences to inclusions.
			const inferredInclusions:MutableSet = new HashSet();
			for (state in normalizedInferences)
				for each (var inferredSubset:TaxonIdentifier : normalizedInferences[state])
				{
					var inclusion:Inclusion = new Inclusion();
					inclusion.superset = state as TaxonIdentifier;
					inclusion.subset = inferredSubset;
					inferredInclusions.add(inclusion);
				}
			return inferredInclusions;
		}
		public static function inferSet(baseSet:FiniteSet, phylogeny:DirectedGraph):FiniteSet
		{
			const childWeights:Dictionary = new Dictionary();
			for each (var taxon:TaxonIdentifier in baseSet)
				childWeights[taxon] = 1.0;
			for each (taxon : phylogeny.vertices)
				if (!childWeights.hasOwnProperty(taxon))
					findChildWeight(taxon, childWeights, phylogeny);
			const result:MutableSet = new HashSet();
			result.addMembers(baseSet);
			for each (taxon : phylogeny.vertices)
				addIfBelongs(result, taxon, childWeights, phylogeny);
			result.removeMembers(baseSet);
			return result;
		}
	}
}