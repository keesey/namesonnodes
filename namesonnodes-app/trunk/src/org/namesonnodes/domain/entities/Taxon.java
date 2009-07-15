package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.ALL;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import org.hibernate.annotations.Cascade;
import org.namesonnodes.domain.PersistentEntity;

@Entity
public final class Taxon extends PersistentEntity implements Identified
{
	private Definition definition;
	private int id;
	public Taxon()
	{
		super();
	}
	public Taxon(final Definition definition)
	{
		super();
		this.definition = definition;
	}
	@Cascade( { ALL })
	@OneToOne(cascade = { CascadeType.ALL })
	public Definition getDefinition()
	{
		return definition;
	}
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "taxon_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "taxon_id_generator", sequenceName = "taxon_id_seq")
	public int getId()
	{
		return id;
	}
	public void setDefinition(final Definition definition)
	{
		this.definition = definition;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	@Override
	public String toString()
	{
		return "<taxon #" + getId() + ">";
	}
}
