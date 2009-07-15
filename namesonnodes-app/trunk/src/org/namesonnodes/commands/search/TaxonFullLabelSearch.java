package org.namesonnodes.commands.search;

import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class TaxonFullLabelSearch extends FullLabelSearch<TaxonIdentifier>
{
	private static final long serialVersionUID = -1014792220076239696L;
	public TaxonFullLabelSearch()
	{
		super(TaxonIdentifier.class);
	}
}
