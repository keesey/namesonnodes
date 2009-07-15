package org.namesonnodes.commands.nomenclature.botanic;

import static org.namesonnodes.utils.CollectionUtil.createSingleton;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicGenusName extends CreateBotanicName
{
	private static final long serialVersionUID = 8269954703135407073L;
	private Command<TaxonIdentifier> typeCommand;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "type", "taxon" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, typeCommand, taxonCommand };
		return v;
	}
	@Override
	protected String getIdentifierAbbr()
	{
		return null;
	}
	public final Command<TaxonIdentifier> getTypeCommand()
	{
		return typeCommand;
	}
	@Override
	protected String rankName()
	{
		return "genus";
	}
	public final void setTypeCommand(final Command<TaxonIdentifier> typeCommand)
	{
		this.typeCommand = typeCommand;
	}
	@Override
	protected Set<TaxonIdentifier> types(final Session session) throws CommandException
	{
		if (typeCommand == null)
			return new HashSet<TaxonIdentifier>();
		final TaxonIdentifier type = acquire(typeCommand, session, "type species");
		if (!type.getAuthority().getUri().equals(BotanicalCode.URI))
			throw new CommandException("Type species must be a botanical species. Instead, the authority is <"
			        + type.getAuthority().getUri() + ">.");
		if (type.getEntity().getDefinition() instanceof RankDefinition)
		{
			final RankDefinition rankDef = (RankDefinition) type.getEntity().getDefinition();
			if (rankDef.getRank() != "species")
				throw new CommandException("Type must refer to a species.");
			if (!type.getLabel().getName().startsWith(name + " "))
				throw new CommandException("Type species must have the genus name as the first part of its binomen.");
		}
		else
			throw new CommandException("Type must be a species, not a taxon which is not rank-defined.");
		return createSingleton(type);
	}
}
