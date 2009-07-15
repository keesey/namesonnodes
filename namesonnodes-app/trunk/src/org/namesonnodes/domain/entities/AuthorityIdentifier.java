package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import static org.namesonnodes.utils.URIUtil.URI_PATTERN;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;
import org.hibernate.validator.Pattern;
import org.namesonnodes.domain.PersistentEntity;

@Entity
@Table(uniqueConstraints = { @UniqueConstraint(columnNames = { "uri" }) })
public final class AuthorityIdentifier extends PersistentEntity implements Identifier<Authority>
{
	private int id;
	private Authority entity;
	private String uri;
	public AuthorityIdentifier()
	{
		super();
	}
	public AuthorityIdentifier(final Authority entity, final String uri)
	{
		super();
		setEntity(entity);
		setUri(uri);
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No entity.")
	public Authority getEntity()
	{
		return entity;
	}
	@Override
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "authorityidentifier_id_generator")
	@SequenceGenerator(name = "authorityidentifier_id_generator", sequenceName = "authorityidentifier_id_seq")
	@Id
	public int getId()
	{
		return id;
	}
	@Column(length = 256)
	@Length(max = 256, min = 5, message = "URI too long or too short.")
	@NotNull(message = "No URI.")
	@Pattern(message = "Invalid URI.", regex = URI_PATTERN)
	// :TODO: schema-specific validation
	// :TODO: Reserve Names on Nodes URIs
	public String getUri()
	{
		return uri;
	}
	public void setEntity(final Authority identity)
	{
		this.entity = identity;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public void setUri(final String uri)
	{
		this.uri = uri;
	}
	@Override
	public String toString()
	{
		return "<" + (uri == null ? "no URI" : uri) + ">";
	}
}
