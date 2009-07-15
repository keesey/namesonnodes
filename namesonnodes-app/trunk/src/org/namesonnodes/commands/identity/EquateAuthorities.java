package org.namesonnodes.commands.identity;

import java.util.Set;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.commands.wrap.WrapSet;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class EquateAuthorities extends Equate<Authority, AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4786388083123438024L;
	public EquateAuthorities()
	{
		super(new FindEquivalentAuthorities());
	}
	public EquateAuthorities(final Authority entity, final Set<Authority> oldEntities)
	{
		super(new FindEquivalentAuthorities());
		setEntityCommand(new WrapEntity<Authority>(entity));
		setOldEntitiesCommand(new WrapSet<Authority>(oldEntities));
	}
}
