package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import javax.persistence.Basic;
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
public final class Heredity extends PersistentEntity
{
	protected int id = 0;
	private TaxonIdentifier predecessor;
	private TaxonIdentifier successor;
	private double weight = 0.0;
	public Heredity()
	{
		super();
	}
	public Heredity(final TaxonIdentifier predecessor, final TaxonIdentifier successor)
	{
		super();
		setPredecessor(predecessor);
		setSuccessor(successor);
	}
	public Heredity(final TaxonIdentifier predecessor, final TaxonIdentifier successor, final double weight)
	{
		this(predecessor, successor);
		setWeight(weight);
	}
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "heredity_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "heredity_id_generator", sequenceName = "heredity_id_seq")
	public int getId()
	{
		return id;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No predecessor.")
	public TaxonIdentifier getPredecessor()
	{
		return predecessor;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No successor.")
	public TaxonIdentifier getSuccessor()
	{
		return successor;
	}
	@Basic
	public double getWeight()
	{
		return weight;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public void setPredecessor(final TaxonIdentifier predecessor)
	{
		if (predecessor != null && successor != null)
			assert !predecessor.getEntity().equals(successor.getEntity());
		this.predecessor = predecessor;
	}
	public void setSuccessor(final TaxonIdentifier successor)
	{
		if (predecessor != null && successor != null)
			assert !predecessor.getEntity().equals(successor.getEntity());
		this.successor = successor;
	}
	public void setWeight(final double weight)
	{
		this.weight = weight;
	}
	@Override
	public final String toString()
	{
		String s = "";
		s += getPredecessor() == null ? "<no predecessor>" : getPredecessor().toString();
		s += " precedes ";
		s += getSuccessor() == null ? "<no successor>" : getSuccessor().toString();
		return s;
	}
}
