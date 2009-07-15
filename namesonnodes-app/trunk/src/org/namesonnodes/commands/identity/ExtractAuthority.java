package org.namesonnodes.commands.identity;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class ExtractAuthority extends ExtractEntity<Authority, AuthorityIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 7152208227985042459L;
	public ExtractAuthority()
	{
		super();
	}
	public ExtractAuthority(final Command<AuthorityIdentifier> identifierCommand)
	{
		super(identifierCommand);
	}
}
