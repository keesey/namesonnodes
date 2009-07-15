package org.namesonnodes.fileformats.nexus;

import org.biojavax.bio.phylo.io.nexus.CharactersBlock;
import org.biojavax.bio.phylo.io.nexus.TaxaBlock;
import org.hibernate.Session;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.fileformats.TaxonTable;

public final class NexusTaxonTable extends TaxonTable
{
	public NexusTaxonTable(final Session session, final AuthorityIdentifier authorityIdentifier)
	{
		super(session, authorityIdentifier);
	}
	@Override
	protected String findStateLocalName(final String charLabel, final String stateLabel)
	{
		return CharactersBlock.CHARACTERS_BLOCK + ":" + super.findStateLocalName(charLabel, stateLabel);
	}
	@Override
	protected String findTaxonLocalName(final String label)
	{
		return TaxaBlock.TAXA_BLOCK + ":" + super.findTaxonLocalName(label);
	}
}
