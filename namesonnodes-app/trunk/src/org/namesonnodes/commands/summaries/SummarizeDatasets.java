package org.namesonnodes.commands.summaries;

import org.namesonnodes.domain.entities.Dataset;

public final class SummarizeDatasets extends Summarize<Dataset>
{
	private static final long serialVersionUID = 3852310627263059583L;
	public SummarizeDatasets()
	{
		super(Dataset.class);
	}
}
