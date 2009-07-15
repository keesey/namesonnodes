package org.namesonnodes.commands.identity;

import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class DifferentiateAuthorities extends Differentiate<Authority, AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -8066229127564026112L;
	@Override
	protected Authority createNewIdentified(final Authority canonical)
	{
		final Authority authority = new Authority();
		authority.setLabel(canonical.getLabel().clone());
		return authority;
	}
}
