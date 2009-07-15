package org.namesonnodes.commands.summaries;

import org.namesonnodes.domain.entities.Authority;

public final class SummarizeAuthorities extends Summarize<Authority>
{
	private static final long serialVersionUID = 0L;
	public SummarizeAuthorities()
	{
		super(Authority.class);
	}
}
