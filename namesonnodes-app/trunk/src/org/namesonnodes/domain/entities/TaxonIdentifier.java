package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.ALL;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import org.hibernate.annotations.Cascade;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.validator.NotNull;

@Entity
@Indexed
@Inheritance(strategy = InheritanceType.JOINED)
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public final class TaxonIdentifier extends Qualified implements Identifier<Taxon>
{
	private Taxon entity;
	public TaxonIdentifier()
	{
		super();
	}
	public TaxonIdentifier(final Taxon entity)
	{
		super();
		this.entity = entity;
	}
	public TaxonIdentifier(final Taxon entity, final AuthorityIdentifier authority)
	{
		super(authority);
		this.entity = entity;
	}
	public TaxonIdentifier(final Taxon entity, final AuthorityIdentifier authority, final String localName)
	{
		super(authority, localName);
		this.entity = entity;
	}
	public TaxonIdentifier(final Taxon entity, final AuthorityIdentifier authority, final String localName,
	        final Label label)
	{
		super(authority, localName, label);
		this.entity = entity;
	}
	public TaxonIdentifier(final TaxonIdentifier original, final AuthorityIdentifier convertingAuthority)
	{
		super();
		setAuthority(convertingAuthority);
		setEntity(new Taxon());
		setLabel(original.getLabel().clone());
		setLocalName(original.getLocalName());
	}
	@Cascade( { ALL })
	@ManyToOne(cascade = { CascadeType.ALL })
	@NotNull(message = "No entity.")
	public final Taxon getEntity()
	{
		return entity;
	}
	public final void setEntity(final Taxon entity)
	{
		this.entity = entity;
	}
}
