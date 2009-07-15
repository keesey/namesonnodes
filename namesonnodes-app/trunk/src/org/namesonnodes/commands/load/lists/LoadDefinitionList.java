package org.namesonnodes.commands.load.lists;

import org.namesonnodes.domain.entities.Definition;

public final class LoadDefinitionList extends LoadList<Definition>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6017811381218741789L;
	public LoadDefinitionList()
	{
		super(Definition.class);
	}
}
