package org.namesonnodes.commands.summaries;

import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class SummarizeAuthorityIdentifiers extends Summarize<AuthorityIdentifier>
{
	private static final long serialVersionUID = 0L;
	public SummarizeAuthorityIdentifiers()
	{
		super(AuthorityIdentifier.class);
	}
}
