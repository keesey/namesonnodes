package org.namesonnodes.commands.nomenclature.zoo;

import org.namesonnodes.commands.nomenclature.ResolveCodeName;

public final class ResolveZooName extends ResolveCodeName
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2246259455778883544L;
	public ResolveZooName()
	{
		super();
	}
	public ResolveZooName(final String name)
	{
		super(name);
	}
	@Override
	protected String getCodeURI()
	{
		return ZoologicalCode.URI;
	}
}
