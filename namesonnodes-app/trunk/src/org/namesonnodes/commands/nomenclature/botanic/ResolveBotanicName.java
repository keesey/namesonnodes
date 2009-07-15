package org.namesonnodes.commands.nomenclature.botanic;

import org.namesonnodes.commands.nomenclature.ResolveCodeName;

public final class ResolveBotanicName extends ResolveCodeName
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4553495213247212800L;
	public ResolveBotanicName()
	{
		super();
	}
	public ResolveBotanicName(final String name)
	{
		super(name);
	}
	@Override
	protected String getCodeURI()
	{
		return BotanicalCode.URI;
	}
}
