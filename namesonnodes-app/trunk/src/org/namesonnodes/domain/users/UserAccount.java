package org.namesonnodes.domain.users;

import static org.namesonnodes.utils.InternetProtocol.isValidAddress;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CollectionOfElements;
import org.hibernate.validator.NotNull;
import org.namesonnodes.domain.PersistentEntity;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Authorized;
import org.namesonnodes.utils.SHA1;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
// @PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public final class UserAccount extends PersistentEntity implements Authorized
{
	private static String getKey(final String ipAddress, final Map<String, String> keys)
	        throws NoSuchAlgorithmException
	{
		if (!isValidAddress(ipAddress))
			return null;
		if (keys.containsKey(ipAddress))
			return keys.get(ipAddress);
		final String key = SHA1.createKey();
		keys.put(ipAddress, key);
		return key;
	}
	private AuthorityIdentifier authority;
	private Map<String, String> confirmationKeys = new HashMap<String, String>();
	private int id;
	private Map<String, String> locationKeys = new HashMap<String, String>();
	public UserAccount()
	{
		super();
	}
	public UserAccount(final AuthorityIdentifier authority)
	{
		super();
		setAuthority(authority);
	}
	@Cascade( { org.hibernate.annotations.CascadeType.ALL })
	@OneToOne(cascade = { CascadeType.ALL })
	@NotNull(message = "No authority for user.")
	// :TODO: Validate authority's URI as an email
	public AuthorityIdentifier getAuthority()
	{
		return authority;
	}
	public final String getConfirmationKey(final String ipAddress) throws NoSuchAlgorithmException
	{
		return getKey(ipAddress, getConfirmationKeys());
	}
	@CollectionOfElements
	// :TODO: IP Address/Hash validation
	public Map<String, String> getConfirmationKeys()
	{
		return confirmationKeys;
	}
	@Override
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "useraccount_id_generator")
	@SequenceGenerator(name = "useraccount_id_generator", sequenceName = "useraccount_id_seq")
	@Id
	public int getId()
	{
		return id;
	}
	public final String getLocationKey(final String ipAddress) throws NoSuchAlgorithmException
	{
		return getKey(ipAddress, getLocationKeys());
	}
	@CollectionOfElements
	// :TODO: IP Address/Hash validation
	public final Map<String, String> getLocationKeys()
	{
		return locationKeys;
	}
	public void setAuthority(final AuthorityIdentifier authority)
	{
		this.authority = authority;
	}
	public void setConfirmationKeys(final Map<String, String> confirmations)
	{
		this.confirmationKeys = confirmations;
	}
	@Override
	public void setId(final int id)
	{
		this.id = id;
	}
	public final void setLocationKeys(final Map<String, String> credentials)
	{
		this.locationKeys = credentials;
	}
	@Override
	public String toString()
	{
		return "<user+"
		        + (authority == null ? "<no authority>" : authority.getUri() == null ? "<no URI>" : authority.getUri())
		        + ">";
	}
}
