package org.namesonnodes.commands.summaries;

import org.namesonnodes.domain.entities.Taxon;

public final class SummarizeTaxa extends Summarize<Taxon>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -7234762289059747873L;
	public SummarizeTaxa()
	{
		super(Taxon.class);
	}
}
