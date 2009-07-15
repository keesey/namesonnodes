package org.namesonnodes.commands.nomenclature.botanic;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicSpeciesName extends CreateBotanicName
{
	private static final long serialVersionUID = -2571300126851182812L;
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
	@Override
	protected String getIdentifierAbbr()
	{
		final String[] names = name.split(" ");
		if (names.length == 2)
			return names[0].charAt(0) + ". " + names[1];
		return null;
	}
	@Override
	protected String rankName()
	{
		return "species";
	}
	@Override
	protected Set<TaxonIdentifier> types(final Session session) throws CommandException
	{
		if (typesCommand == null)
			return new HashSet<TaxonIdentifier>();
		final Set<TaxonIdentifier> types = new HashSet<TaxonIdentifier>(
		        acquire(typesCommand, session, "type specimens"));
		for (final TaxonIdentifier type : types)
			if (type.getEntity().getDefinition() != null)
				throw new CommandException(type.getLabel().getName()
				        + " is defined; a specimen identifier was expected.");
		return types;
	}
}
