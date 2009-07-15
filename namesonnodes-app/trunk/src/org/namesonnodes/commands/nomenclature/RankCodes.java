package org.namesonnodes.commands.nomenclature;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.bacterial.BacteriologicalCode;
import org.namesonnodes.commands.nomenclature.botanic.BotanicalCode;
import org.namesonnodes.commands.nomenclature.zoo.ZoologicalCode;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class RankCodes implements Command<Set<AuthorityIdentifier>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3111720201287855451L;
	private final Set<RankCode> rankCodes = new HashSet<RankCode>();
	public RankCodes()
	{
		super();
		rankCodes.add(new BacteriologicalCode());
		rankCodes.add(new BotanicalCode());
		rankCodes.add(new ZoologicalCode());
	}
	public void clearResult()
	{
		for (final RankCode code : rankCodes)
			code.clearResult();
	}
	public Set<AuthorityIdentifier> execute(final Session session) throws CommandException
	{
		final Set<AuthorityIdentifier> codes = new HashSet<AuthorityIdentifier>();
		for (final RankCode code : rankCodes)
			codes.add(code.execute(session));
		return codes;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public String toCommandString()
	{
		return "RankCodes";
	}
}
