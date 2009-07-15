package org.namesonnodes.commands.load.sets;

import org.namesonnodes.commands.load.Load;
import org.namesonnodes.domain.entities.Dataset;

public final class LoadDatasetSet extends Load<Dataset>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8587900204895450534L;
	public LoadDatasetSet()
	{
		super(Dataset.class);
	}
}
