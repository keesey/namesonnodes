package org.namesonnodes.domain.constructs;

import java.util.HashSet;
import java.util.Set;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class PotentialEquivalence
{
	private TaxonIdentifier a;
	private TaxonIdentifier b;
	private boolean inclusionPossible = false;
	public PotentialEquivalence(final TaxonIdentifier a, final TaxonIdentifier b, final boolean inclusionPossible)
	{
		super();
		this.a = a;
		this.b = b;
		this.inclusionPossible = inclusionPossible;
	}
	public TaxonIdentifier getA()
	{
		return a;
	}
	public TaxonIdentifier getB()
	{
		return b;
	}
	public boolean getInclusionPossible()
	{
		return inclusionPossible;
	}
	public void setA(final TaxonIdentifier a)
	{
		this.a = a;
	}
	public void setB(final TaxonIdentifier b)
	{
		this.b = b;
	}
	public void setInclusionPossible(final boolean inclusionPossible)
	{
		this.inclusionPossible = inclusionPossible;
	}
	public Set<TaxonIdentifier> toSet()
	{
		final Set<TaxonIdentifier> set = new HashSet<TaxonIdentifier>();
		set.add(a);
		set.add(b);
		return set;
	}
	@Override
	public String toString()
	{
		return a.toString() + " ?" + (inclusionPossible ? "⊇" : "=") + " " + b.toString();
	}
}
