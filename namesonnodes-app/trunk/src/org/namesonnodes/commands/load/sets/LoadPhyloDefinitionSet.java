package org.namesonnodes.commands.load.sets;

import org.namesonnodes.commands.load.Load;
import org.namesonnodes.domain.entities.PhyloDefinition;

public final class LoadPhyloDefinitionSet extends Load<PhyloDefinition>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 475851058571856054L;
	public LoadPhyloDefinitionSet()
	{
		super(PhyloDefinition.class);
	}
}
