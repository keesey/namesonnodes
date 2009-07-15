package org.namesonnodes.fileformats;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import org.jgrapht.DirectedGraph;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleDirectedGraph;
import org.namesonnodes.domain.entities.Heredity;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class InclusionInference
{
	private static <T> boolean addIfBelongs(final Set<T> set, final T identity, final Map<T, Double> childWeights,
	        final DirectedGraph<T, DefaultEdge> phylogeny)
	{
		if (set.contains(identity))
			return true;
		final double weight = childWeights.get(identity);
		if (weight > 0.5001)
		{
			set.add(identity);
			return true;
		}
		if (weight > 0.0001)
		{
			final Set<T> parents = new HashSet<T>();
			for (final DefaultEdge edge : phylogeny.incomingEdgesOf(identity))
				parents.add(phylogeny.getEdgeSource(edge));
			for (final T parent : parents)
				if (addIfBelongs(set, parent, childWeights, phylogeny))
				{
					set.add(identity);
					return true;
				}
		}
		return false;
	}
	private static DirectedGraph<TaxonIdentifier, DefaultEdge> derivePhylogeny(final Collection<Heredity> heredities)
	{
		final SimpleDirectedGraph<TaxonIdentifier, DefaultEdge> phylogeny = new SimpleDirectedGraph<TaxonIdentifier, DefaultEdge>(
		        DefaultEdge.class);
		for (final Heredity heredity : heredities)
		{
			phylogeny.addVertex(heredity.getPredecessor());
			phylogeny.addVertex(heredity.getSuccessor());
			phylogeny.addEdge(heredity.getPredecessor(), heredity.getSuccessor());
		}
		return phylogeny;
	}
	private static <T> double findChildWeight(final T identity, final Map<T, Double> childWeights,
	        final DirectedGraph<T, DefaultEdge> phylogeny)
	{
		if (childWeights.containsKey(identity))
			return childWeights.get(identity);
		final Set<T> children = new HashSet<T>();
		for (final DefaultEdge edge : phylogeny.outgoingEdgesOf(identity))
			children.add(phylogeny.getEdgeTarget(edge));
		if (children.isEmpty())
		{
			childWeights.put(identity, 0.0);
			return 0.0;
		}
		double total = 0.0;
		for (final T child : children)
			total += findChildWeight(child, childWeights, phylogeny);
		final double average = total / children.size();
		childWeights.put(identity, average);
		return average;
	}
	public static Set<Inclusion> inferInclusions(final Map<TaxonIdentifier, Set<TaxonIdentifier>> scoreMap,
	        final Collection<Heredity> heredities)
	{
		// Derive phylogeny.
		final DirectedGraph<TaxonIdentifier, DefaultEdge> phylogeny = derivePhylogeny(heredities);
		// Build inferences.
		final Map<TaxonIdentifier, Set<TaxonIdentifier>> inferences = new HashMap<TaxonIdentifier, Set<TaxonIdentifier>>();
		final Map<TaxonIdentifier, Set<TaxonIdentifier>> normalizedInferences = new HashMap<TaxonIdentifier, Set<TaxonIdentifier>>();
		for (final TaxonIdentifier state : scoreMap.keySet())
		{
			final Set<TaxonIdentifier> inferredSet = inferSet(scoreMap.get(state), phylogeny);
			inferences.put(state, inferredSet);
			normalizedInferences.put(state, inferredSet);
		}
		// Normalize to minimize number of inclusions.
		for (final TaxonIdentifier stateA : inferences.keySet())
		{
			final Set<TaxonIdentifier> aSub = inferences.get(stateA);
			if (!aSub.isEmpty())
				for (final TaxonIdentifier stateB : inferences.keySet())
					if (stateA != stateB)
					{
						final Set<TaxonIdentifier> bSub = inferences.get(stateB);
						if (!bSub.isEmpty() && aSub.size() > bSub.size() && aSub.containsAll(bSub))
							// Proper superset found; normalize inferred
							// subsets.
							normalizedInferences.get(stateA).removeAll(bSub);
					}
		}
		// Convert inferences to inclusions.
		final Set<Inclusion> inferredInclusions = new HashSet<Inclusion>();
		for (final TaxonIdentifier state : normalizedInferences.keySet())
			for (final TaxonIdentifier inferredSubset : normalizedInferences.get(state))
				inferredInclusions.add(new Inclusion(state, inferredSubset));
		return inferredInclusions;
	}
	public static <T> Set<T> inferSet(final Set<T> baseSet, final DirectedGraph<T, DefaultEdge> phylogeny)
	{
		final Map<T, Double> childWeights = new HashMap<T, Double>();
		for (final T identity : baseSet)
			childWeights.put(identity, 1.0);
		for (final T identity : phylogeny.vertexSet())
			if (!childWeights.containsKey(identity))
				findChildWeight(identity, childWeights, phylogeny);
		final Set<T> result = new HashSet<T>();
		result.addAll(baseSet);
		for (final T identity : phylogeny.vertexSet())
			addIfBelongs(result, identity, childWeights, phylogeny);
		result.removeAll(baseSet);
		return result;
	}
}
