package org.namesonnodes.commands.nomenclature.botanic;

import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getRankNameFromTaxonName;
import static org.namesonnodes.utils.URIUtil.escape;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicSubspecificName extends CreateBotanicName
{
	private static final long serialVersionUID = -4249136598659883034L;
	private Command<? extends Collection<TaxonIdentifier>> typesCommand;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "types", "taxon" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, typesCommand, taxonCommand };
		return v;
	}
	private void checkSpecificDefinition(final Session session, final Set<TaxonIdentifier> types)
	        throws CommandException
	{
		final String[] names = name.split(" ");
		if (names.length != 4)
			throw new CommandException("Invalid botanical " + rankName() + " name.");
		if (names[1].equals(names[3]))
		{
			final TaxonIdentifier species = new ResolveTaxonIdentifier(BotanicalCode.URI + "::"
			        + escape(names[0] + " " + names[1])).execute(session);
			if (species != null)
				if (species.getEntity().getDefinition() == null)
					createSpecificDefinition(session, types, species);
				else if (species.getEntity().getDefinition() instanceof RankDefinition)
				{
					if (!((RankDefinition) species.getEntity().getDefinition()).getTypes().equals(types))
						throw new CommandException(species.getLabel().getName() + " has different typification than "
						        + name + ".");
				}
				else
					throw new CommandException("Species " + species.getLabel().getName()
					        + " has an non-rank-based definition.");
		}
	}
	private void createSpecificDefinition(final Session session, final Set<TaxonIdentifier> types,
	        final TaxonIdentifier species)
	{
		final String rank = rankName();
		final RankDefinition definition = new RankDefinition();
		definition.setLevel(BotanicalRank.getLevel(rank));
		definition.setRank(rank);
		definition.setTypes(types);
		species.getEntity().setDefinition(definition);
		commitRequired = true;
	}
	@Override
	protected String getIdentifierAbbr()
	{
		final String[] names = name.split(" ");
		if (names.length == 4)
			return names[0].charAt(0) + ". " + names[1].charAt(0) + ". " + names[2] + " " + names[3];
		return null;
	}
	@Override
	protected String rankName()
	{
		return getRankNameFromTaxonName(name);
	}
	@Override
	protected Set<TaxonIdentifier> types(final Session session) throws CommandException
	{
		// :TODO: Check against species types.
		if (typesCommand == null)
			return new HashSet<TaxonIdentifier>();
		final Set<TaxonIdentifier> types = new HashSet<TaxonIdentifier>(
		        acquire(typesCommand, session, "type specimens"));
		for (final TaxonIdentifier type : types)
			if (type.getEntity().getDefinition() != null)
				throw new CommandException(type.getLabel().getName()
				        + " is defined; a specimen identifier was expected.");
		checkSpecificDefinition(session, types);
		return types;
	}
}
