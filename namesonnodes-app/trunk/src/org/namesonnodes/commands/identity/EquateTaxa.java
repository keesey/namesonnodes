package org.namesonnodes.commands.identity;

import java.util.HashSet;
import java.util.Set;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.commands.wrap.WrapSet;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class EquateTaxa extends Equate<Taxon, TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4550808227865006942L;
	public EquateTaxa()
	{
		super(new FindEquivalentTaxa());
	}
	public EquateTaxa(final Taxon entity, final Set<Taxon> oldEntities)
	{
		super(new FindEquivalentTaxa());
		setEntityCommand(new WrapEntity<Taxon>(entity));
		setOldEntitiesCommand(new WrapSet<Taxon>(oldEntities));
	}
	public EquateTaxa(final Taxon entity, final Taxon oldEntity)
	{
		super(new FindEquivalentTaxa());
		setEntityCommand(new WrapEntity<Taxon>(entity));
		final Set<Taxon> oldEntities = new HashSet<Taxon>();
		oldEntities.add(oldEntity);
		setOldEntitiesCommand(new WrapSet<Taxon>(oldEntities));
	}
}
