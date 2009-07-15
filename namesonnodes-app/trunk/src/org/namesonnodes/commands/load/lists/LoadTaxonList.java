package org.namesonnodes.commands.load.lists;

import org.namesonnodes.domain.entities.Taxon;

public final class LoadTaxonList extends LoadList<Taxon>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 7406415894312240840L;
	public LoadTaxonList()
	{
		super(Taxon.class);
	}
}
