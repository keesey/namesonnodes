package org.namesonnodes.commands.nomenclature.botanic;

import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.RankCode;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class BotanicalCode implements RankCode
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 877287246869661886L;
	public static final String URI = "urn:isbn:3906166481";
	private final ResolveURI resolve = new ResolveURI(URI);
	public void clearResult()
	{
		resolve.clearResult();
	}
	public AuthorityIdentifier execute(final Session session) throws CommandException
	{
		return resolve.execute(session);
	}
	public boolean readOnly()
	{
		return resolve.readOnly();
	}
	public boolean requiresCommit()
	{
		return resolve.requiresCommit();
	}
	public String toCommandString()
	{
		return "BotanicalCode";
	}
}
