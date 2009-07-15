package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import static org.namesonnodes.utils.CollectionUtil.join;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.SequenceGenerator;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.Size;
import org.namesonnodes.domain.PersistentEntity;

@Entity
public final class Synonymy extends PersistentEntity
{
	private int id;
	private Set<TaxonIdentifier> synonyms = new HashSet<TaxonIdentifier>();
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "synonymy_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "synonymy_id_generator", sequenceName = "synonymy_id_seq")
	public int getId()
	{
		return id;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@Size(min = 2, message = "Synonymy must have at least two synonyms.")
	public final Set<TaxonIdentifier> getSynonyms()
	{
		return synonyms;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public final void setSynonyms(final Set<TaxonIdentifier> synonyms)
	{
		this.synonyms = synonyms;
	}
	@Override
	public String toString()
	{
		if (getSynonyms().isEmpty())
			return "<no equivalents>";
		String s = join(getSynonyms(), " = ");
		if (getSynonyms().size() == 1)
			s += " = ?";
		return s;
	}
}
