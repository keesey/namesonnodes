package org.namesonnodes.commands.authorization;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;

public final class FindDatasets extends FindAuthorized<Dataset>
{
	private static final long serialVersionUID = -6291394800836404279L;
	public FindDatasets()
	{
		super(Dataset.class);
	}
	public FindDatasets(final Command<AuthorityIdentifier> authorityCommand)
	{
		super(Dataset.class, authorityCommand);
	}
}
