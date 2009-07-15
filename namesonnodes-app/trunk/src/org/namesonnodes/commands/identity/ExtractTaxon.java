package org.namesonnodes.commands.identity;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ExtractTaxon extends ExtractEntity<Taxon, TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2265485596438719943L;
	public ExtractTaxon()
	{
		super();
	}
	public ExtractTaxon(final Command<TaxonIdentifier> identifierCommand)
	{
		super(identifierCommand);
	}
}
