package org.namesonnodes.commands.load.sets;

import org.namesonnodes.commands.load.Load;
import org.namesonnodes.domain.entities.Definition;

public final class LoadDefinitionSet extends Load<Definition>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -1776343868818809043L;
	public LoadDefinitionSet()
	{
		super(Definition.class);
	}
}
