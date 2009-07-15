package org.namesonnodes.commands.load;

import org.namesonnodes.domain.entities.Taxon;

public final class LoadTaxon extends Load<Taxon>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2896211401533697505L;
	public LoadTaxon()
	{
		super(Taxon.class);
	}
}
