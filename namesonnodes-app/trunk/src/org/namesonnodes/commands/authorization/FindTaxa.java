package org.namesonnodes.commands.authorization;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class FindTaxa extends FindAuthorized<TaxonIdentifier>
{
	private static final long serialVersionUID = -9117516107805596686L;
	public FindTaxa()
	{
		super(TaxonIdentifier.class);
	}
	public FindTaxa(final Command<AuthorityIdentifier> authorityCommand)
	{
		super(TaxonIdentifier.class, authorityCommand);
	}
}
