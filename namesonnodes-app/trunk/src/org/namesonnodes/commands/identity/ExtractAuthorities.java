package org.namesonnodes.commands.identity;

import java.util.List;
import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class ExtractAuthorities extends ExtractEntities<Authority, AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8468535280404560485L;
	public ExtractAuthorities()
	{
		super();
	}
	public ExtractAuthorities(final Command<? extends List<AuthorityIdentifier>> identifiersCommand)
	{
		super(identifiersCommand);
	}
}
