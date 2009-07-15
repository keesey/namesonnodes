package org.namesonnodes.commands.nomenclature.phylo;

import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.NomenclaturalCode;
import org.namesonnodes.commands.resolve.ResolveURI;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class PhyloCode implements NomenclaturalCode
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3629611317447090222L;
	public static final String URI = "http://www.ohiou.edu/phylocode/PhyloCode4b.doc";
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
