package org.namesonnodes.commands.identity;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class FindEquivalentAuthorities extends FindEquivalentEntities<Authority, AuthorityIdentifier>
{
	private static final long serialVersionUID = 2878701336001625866L;
	public FindEquivalentAuthorities()
	{
		super();
	}
	public FindEquivalentAuthorities(final Command<Authority> entityCommand)
	{
		super(entityCommand);
	}
	@Override
	protected Class<AuthorityIdentifier> getIdentifierClass()
	{
		return AuthorityIdentifier.class;
	}
}
