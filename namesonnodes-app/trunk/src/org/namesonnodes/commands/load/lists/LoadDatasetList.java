package org.namesonnodes.commands.load.lists;

import org.namesonnodes.domain.entities.Dataset;

public final class LoadDatasetList extends LoadList<Dataset>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2287585577721537010L;
	public LoadDatasetList()
	{
		super(Dataset.class);
	}
}
