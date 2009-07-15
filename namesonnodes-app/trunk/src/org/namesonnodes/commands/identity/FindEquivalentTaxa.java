package org.namesonnodes.commands.identity;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class FindEquivalentTaxa extends FindEquivalentEntities<Taxon, TaxonIdentifier>
{
	private static final long serialVersionUID = 4138014579406956951L;
	public FindEquivalentTaxa()
	{
		super();
	}
	public FindEquivalentTaxa(final Command<Taxon> entityCommand)
	{
		super(entityCommand);
	}
	@Override
	protected Class<TaxonIdentifier> getIdentifierClass()
	{
		return TaxonIdentifier.class;
	}
}
