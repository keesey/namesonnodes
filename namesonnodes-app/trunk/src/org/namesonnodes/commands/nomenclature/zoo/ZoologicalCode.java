package org.namesonnodes.commands.nomenclature.zoo;

import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.RankCode;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class ZoologicalCode implements RankCode
{
	private static final long serialVersionUID = 4119252588061124043L;
	public static final String URI = "urn:isbn:0853010064";
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
		return "ZoologicalCode";
	}
}
