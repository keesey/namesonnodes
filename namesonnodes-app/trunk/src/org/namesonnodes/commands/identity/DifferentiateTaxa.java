package org.namesonnodes.commands.identity;

import org.namesonnodes.domain.entities.SpecimenDefinition;
import org.namesonnodes.domain.entities.StateDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class DifferentiateTaxa extends Differentiate<Taxon, TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6896058693098199204L;
	@Override
	protected Taxon createNewIdentified(final Taxon canonical)
	{
		final Taxon taxon = new Taxon();
		if (canonical.getDefinition() instanceof StateDefinition)
			taxon.setDefinition(new StateDefinition());
		else if (canonical.getDefinition() instanceof SpecimenDefinition)
			taxon.setDefinition(new SpecimenDefinition());
		return taxon;
	}
}
