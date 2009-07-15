package org.namesonnodes.commands.nomenclature.bacterial;

import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.RankCode;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class BacteriologicalCode implements RankCode
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -890875437948713692L;
	public static final String URI = "urn:doi:10.1111/j.1574-6968.1992.tb05316.x";
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
		return "BacteriologicalCode";
	}
}
