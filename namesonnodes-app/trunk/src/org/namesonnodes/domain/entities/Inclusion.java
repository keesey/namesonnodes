package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.NotNull;
import org.namesonnodes.domain.PersistentEntity;

@Entity
public final class Inclusion extends PersistentEntity
{
	public static Set<Inclusion> createSet(final TaxonIdentifier superset, final Set<TaxonIdentifier> subsets)
	{
		final Set<Inclusion> inclusions = new HashSet<Inclusion>();
		for (final TaxonIdentifier subset : subsets)
			inclusions.add(new Inclusion(superset, subset));
		return inclusions;
	}
	protected int id = 0;
	private TaxonIdentifier subset;
	private TaxonIdentifier superset;
	public Inclusion()
	{
		super();
	}
	public Inclusion(final TaxonIdentifier superset, final TaxonIdentifier subset)
	{
		super();
		setSuperset(superset);
		setSubset(subset);
	}
	@Override
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "inclusion_id_generator")
	@SequenceGenerator(name = "inclusion_id_generator", sequenceName = "inclusion_id_seq")
	@Id
	public int getId()
	{
		return id;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No subset.")
	public TaxonIdentifier getSubset()
	{
		return subset;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No superset.")
	public TaxonIdentifier getSuperset()
	{
		return superset;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public void setSubset(final TaxonIdentifier subset)
	{
		this.subset = subset;
	}
	public void setSuperset(final TaxonIdentifier superset)
	{
		this.superset = superset;
	}
	@Override
	public final String toString()
	{
		String s = "";
		s += getSuperset() == null ? "<no superset>" : getSuperset().toString();
		s += " includes ";
		s += getSubset() == null ? "<no subset>" : getSubset().toString();
		return s;
	}
}
