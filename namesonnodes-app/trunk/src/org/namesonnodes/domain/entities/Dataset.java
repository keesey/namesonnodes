package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.ALL;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import org.hibernate.annotations.Cascade;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.validator.NotNull;

@Entity
@Indexed
@Inheritance(strategy = InheritanceType.JOINED)
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public final class Dataset extends Qualified
{
	private Set<Heredity> heredities = new HashSet<Heredity>();
	private Set<Inclusion> inclusions = new HashSet<Inclusion>();
	private Set<Synonymy> synonymies = new HashSet<Synonymy>();
	private double weightPerGeneration;
	private double weightPerYear;
	public Set<Taxon> collectTaxa()
	{
		final Set<Taxon> taxa = new HashSet<Taxon>();
		for (final Synonymy synonymy : getSynonymies())
			for (final TaxonIdentifier identifier : synonymy.getSynonyms())
				taxa.add(identifier.getEntity());
		for (final Heredity heredity : getHeredities())
		{
			taxa.add(heredity.getPredecessor().getEntity());
			taxa.add(heredity.getSuccessor().getEntity());
		}
		for (final Inclusion inclusion : getInclusions())
		{
			taxa.add(inclusion.getSuperset().getEntity());
			taxa.add(inclusion.getSubset().getEntity());
		}
		return taxa;
	}
	@Cascade( { ALL })
	@OneToMany(cascade = CascadeType.ALL)
	public final Set<Heredity> getHeredities()
	{
		return heredities;
	}
	@Cascade( { ALL })
	@OneToMany(cascade = CascadeType.ALL)
	public final Set<Inclusion> getInclusions()
	{
		return inclusions;
	}
	@Cascade( { ALL })
	@OneToMany(cascade = CascadeType.ALL)
	public final Set<Synonymy> getSynonymies()
	{
		return synonymies;
	}
	@Basic
	@NotNull
	public final double getWeightPerGeneration()
	{
		return weightPerGeneration;
	}
	@Basic
	@NotNull
	public final double getWeightPerYear()
	{
		return weightPerYear;
	}
	public final void setHeredities(final Set<Heredity> heredities)
	{
		this.heredities = heredities;
	}
	public final void setInclusions(final Set<Inclusion> inclusions)
	{
		this.inclusions = inclusions;
	}
	public final void setSynonymies(final Set<Synonymy> synonymies)
	{
		this.synonymies = synonymies;
	}
	public final void setWeightPerGeneration(final double weightPerGeneration)
	{
		this.weightPerGeneration = weightPerGeneration;
	}
	public final void setWeightPerYear(final double weightPerYear)
	{
		this.weightPerYear = weightPerYear;
	}
}
