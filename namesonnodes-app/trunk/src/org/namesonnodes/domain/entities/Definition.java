package org.namesonnodes.domain.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.SequenceGenerator;
import org.namesonnodes.domain.PersistentEntity;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
// @PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public abstract class Definition extends PersistentEntity
{
	private int id;
	public Definition()
	{
		super();
	}
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "definition_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "definition_id_generator", sequenceName = "definition_id_seq")
	public final int getId()
	{
		return id;
	}
	@Override
	public final void setId(final int id)
	{
		this.id = id;
	}
	protected abstract String toFormulaString();
	@Override
	public final String toString()
	{
		return ":= " + toFormulaString();
	}
}
