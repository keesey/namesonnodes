package org.namesonnodes.validators.ip;

import static org.namesonnodes.utils.InternetProtocol.isValidAddress;
import java.io.Serializable;
import org.hibernate.validator.Validator;

public final class IPAddressValidator implements Serializable, Validator<IPAddress>
{
	private static final long serialVersionUID = 1L;
	public void initialize(final IPAddress parameters)
	{
		// Do nothing.
	}
	public boolean isValid(final Object value)
	{
		if (value == null)
			return false;
		return isValidAddress(value.toString());
	}
}
