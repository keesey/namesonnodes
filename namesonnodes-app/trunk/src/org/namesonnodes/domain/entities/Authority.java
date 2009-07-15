package org.namesonnodes.domain.entities;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import org.hibernate.search.annotations.DocumentId;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.search.annotations.IndexedEmbedded;
import org.namesonnodes.domain.PersistentEntity;

@Entity
@Indexed
public final class Authority extends PersistentEntity implements Identified, Labelled
{
	private int id;
	private Label label;
	public Authority()
	{
		super();
	}
	public Authority(final Label label)
	{
		super();
		this.label = label;
	}
	@DocumentId
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "authority_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "authority_id_generator", sequenceName = "authority_id_seq")
	public final int getId()
	{
		return id;
	}
	@Embedded
	@IndexedEmbedded
	public final Label getLabel()
	{
		if (label == null)
			label = new Label();
		return label;
	}
	@Override
	public final void setId(final int id)
	{
		this.id = id;
	}
	public final void setLabel(final Label label)
	{
		this.label = label;
	}
	@Override
	public String toString()
	{
		return getLabel().toString();
	}
}
