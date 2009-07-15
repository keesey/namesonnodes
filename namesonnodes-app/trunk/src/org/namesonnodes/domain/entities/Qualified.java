package org.namesonnodes.domain.entities;

import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import org.hibernate.annotations.Cascade;
import org.hibernate.search.annotations.DocumentId;
import org.hibernate.search.annotations.IndexedEmbedded;
import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;
import org.hibernate.validator.Pattern;
import org.namesonnodes.domain.PersistentEntity;

@Entity
// @Indexed
@Inheritance(strategy = InheritanceType.JOINED)
// @PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
@Table(uniqueConstraints = { @UniqueConstraint(columnNames = { "QName" }) })
public abstract class Qualified extends PersistentEntity implements Authorized, Labelled
{
	private AuthorityIdentifier authority;
	private int id;
	private Label label;
	private String localName;
	private String qName;
	public Qualified()
	{
		super();
	}
	public Qualified(final AuthorityIdentifier authority)
	{
		super();
		this.authority = authority;
	}
	public Qualified(final AuthorityIdentifier authority, final String localName)
	{
		super();
		this.authority = authority;
		this.localName = localName;
	}
	public Qualified(final AuthorityIdentifier authority, final String localName, final Label label)
	{
		super();
		this.authority = authority;
		this.localName = localName;
		this.label = label;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToOne(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH })
	@NotNull(message = "No authority.")
	public AuthorityIdentifier getAuthority()
	{
		return authority;
	}
	@DocumentId
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "qualified_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "qualified_id_generator", sequenceName = "qualified_id_seq")
	public final int getId()
	{
		return id;
	}
	@Embedded
	@IndexedEmbedded
	public Label getLabel()
	{
		if (label == null)
			label = new Label();
		return label;
	}
	@Column(length = 128)
	@Length(min = 1, max = 128, message = "Empty local name, or local name too long.")
	@NotNull(message = "No local name.")
	@Pattern(regex = "^[A-Za-z0-9_+%:/-]+$", message = "Invalid local name; segments must be URI-escaped.")
	public String getLocalName()
	{
		return localName;
	}
	@Column(length = 386)
	@NotNull
	public String getQName()
	{
		if (qName == null && authority != null && authority.getUri() != null && authority.getUri().length() != 0
		        && localName != null && localName.length() != 0)
			setQName(authority.getUri() + "::" + localName);
		return qName;
	}
	public void setAuthority(final AuthorityIdentifier authority)
	{
		this.authority = authority;
		qName = null;
	}
	@Override
	public final void setId(final int id)
	{
		this.id = id;
	}
	public void setLabel(final Label label)
	{
		this.label = label;
	}
	public void setLocalName(final String localName)
	{
		this.localName = localName;
		qName = null;
	}
	public void setQName(final String qName)
	{
		this.qName = qName;
	}
	@Override
	public final String toString()
	{
		String s = "<";
		if (authority == null)
			s += "<no authority>";
		else if (authority.getUri() == null || authority.getUri().length() == 0)
			s += "<no URI>";
		else
			s += authority.getUri();
		s += "::";
		if (localName == null || localName.length() == 0)
			s += "<no local name>";
		else
			s += localName;
		return s + ">";
	}
}
