package org.namesonnodes.commands.load.sets;

import org.namesonnodes.domain.entities.Taxon;

public final class LoadTaxonSet extends LoadSet<Taxon>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6465688209503105617L;
	public LoadTaxonSet()
	{
		super(Taxon.class);
	}
}
