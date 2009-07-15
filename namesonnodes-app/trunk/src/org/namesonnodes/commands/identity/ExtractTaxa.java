package org.namesonnodes.commands.identity;

import java.util.List;
import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ExtractTaxa extends ExtractEntities<Taxon, TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5279914046044405277L;
	public ExtractTaxa()
	{
		super();
	}
	public ExtractTaxa(final Command<? extends List<TaxonIdentifier>> identifiersCommand)
	{
		super(identifiersCommand);
	}
}
