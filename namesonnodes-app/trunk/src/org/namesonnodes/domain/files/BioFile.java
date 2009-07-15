package org.namesonnodes.domain.files;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Lob;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.UniqueConstraint;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.NotNull;
import org.hibernate.validator.Pattern;
import org.namesonnodes.domain.PersistentEntity;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Authorized;
import org.namesonnodes.utils.SHA1;
import org.namesonnodes.validators.ip.IPAddress;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
// @PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
@Table(uniqueConstraints = { @UniqueConstraint(columnNames = { "sourceHash" }) })
public final class BioFile extends PersistentEntity implements Authorized
{
	private AuthorityIdentifier authority;
	private int id;
	private String ipAddress = "";
	private char[] source = new char[0];
	private String sourceHash = "";
	private Date timeUploaded = new Date();
	public BioFile()
	{
		super();
	}
	public BioFile(final AuthorityIdentifier authority, final String ipAddress, final char[] source)
	        throws NoSuchAlgorithmException, IOException
	{
		super();
		setAuthority(authority);
		setIpAddress(ipAddress);
		setSource(source);
	}
	@Cascade( { org.hibernate.annotations.CascadeType.ALL })
	@OneToOne(cascade = { CascadeType.ALL })
	@NotNull(message = "No authority for file.")
	public AuthorityIdentifier getAuthority()
	{
		return authority;
	}
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "biofile_id_generator")
	@Id
	@Override
	@SequenceGenerator(name = "biofile_id_generator", sequenceName = "biofile_id_seq")
	public int getId()
	{
		return id;
	}
	@Column(length = 39)
	@IPAddress(message = "Invalid IP address.")
	@NotNull(message = "No IP address for file.")
	public String getIpAddress()
	{
		return ipAddress;
	}
	@Lob
	@NotNull(message = "No data for file.")
	public char[] getSource()
	{
		return source;
	}
	@Column(length = 40)
	@NotNull(message = "Error in file.")
	@Pattern(regex = "^[a-f0-9]{40}$", message = "Error in file.")
	public String getSourceHash()
	{
		return sourceHash;
	}
	@NotNull(message = "No timestamp for file.")
	@Temporal(value = TemporalType.TIMESTAMP)
	public Date getTimeUploaded()
	{
		return timeUploaded;
	}
	public void setAuthority(final AuthorityIdentifier authorityIdentifier)
	{
		this.authority = authorityIdentifier;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public void setIpAddress(final String ipAddress)
	{
		this.ipAddress = ipAddress == null ? "" : ipAddress.toLowerCase();
	}
	public void setSource(final char[] source) throws NoSuchAlgorithmException, IOException
	{
		sourceHash = SHA1.encrypt(source);
		if (sourceHash.length() != 40)
			throw new RuntimeException("Invalid source hash: " + sourceHash);
		this.source = source;
	}
	public void setSourceHash(final String sourceHash)
	{
	}
	public void setTimeUploaded(final Date timeUploaded)
	{
		if (timeUploaded != null)
			this.timeUploaded = timeUploaded;
	}
	@Override
	public String toString()
	{
		return "biofile+"
		        + (authority == null ? "<no authority>" : authority.getUri() == null ? "<no URI>" : authority.getUri());
	}
	public String toURI()
	{
		return "urn:sha1:" + getSourceHash();
	}
}
