package org.namesonnodes.commands.nomenclature.phylo;

import org.namesonnodes.commands.nomenclature.ResolveCodeName;

public final class ResolvePhyloName extends ResolveCodeName
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8923390006234795477L;
	public ResolvePhyloName()
	{
		super();
	}
	public ResolvePhyloName(final String name)
	{
		super(name);
	}
	@Override
	protected String getCodeURI()
	{
		return PhyloCode.URI;
	}
}
