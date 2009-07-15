package org.namesonnodes.commands.nomenclature.bacterial;

import org.namesonnodes.commands.nomenclature.ResolveCodeName;

public final class ResolveBacterialName extends ResolveCodeName
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6438286680717404890L;
	public ResolveBacterialName()
	{
		super();
	}
	public ResolveBacterialName(final String name)
	{
		super(name);
	}
	@Override
	protected String getCodeURI()
	{
		return BacteriologicalCode.URI;
	}
}
