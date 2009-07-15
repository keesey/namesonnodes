package org.namesonnodes.commands.nomenclature.botanic;

import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getPattern;
import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getRankNameFromTaxonName;
import static org.namesonnodes.utils.CollectionUtil.createSingleton;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicSupragenericName extends CreateBotanicName
{
	private static final long serialVersionUID = 7148485060458542089L;
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
	private void checkRank(final String rank) throws CommandException
	{
		final double level = BotanicalRank.getLevel(rank);
		if (level <= BotanicalRank.getLevel("genus"))
			throw new CommandException(name + " does not appear to be a botanical suprageneric name.");
	}
	private void checkType(final TaxonIdentifier type, final String rank) throws CommandException
	{
		final Pattern pattern = Pattern.compile(getPattern(rank));
		final Matcher matcher = pattern.matcher(name);
		if (!matcher.matches())
			throw new CommandException("Invalid name for botanical " + rank + ".");
		String root = matcher.group(1);
		if (root.length() > 2)
			root = root.substring(0, root.length() - 2);
		if (!type.getAuthority().getUri().equals(BotanicalCode.URI))
			throw new CommandException("Type species must be a botanical genus. Instead, the authority is <"
			        + type.getAuthority().getUri() + ">.");
		if (!type.getLabel().getName().startsWith(root))
			throw new CommandException(name + " does not appear to be the proper name for a " + rank + " typified by "
			        + type.getLabel().getName() + ".");
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
		return getRankNameFromTaxonName(name);
	}
	public final void setTypeCommand(final Command<TaxonIdentifier> typeCommand)
	{
		this.typeCommand = typeCommand;
	}
	@Override
	protected Set<TaxonIdentifier> types(final Session session) throws CommandException
	{
		// :TODO: Check against other higher group types.
		if (typeCommand == null)
			return new HashSet<TaxonIdentifier>();
		final TaxonIdentifier type = acquire(typeCommand, session, "type genus");
		if (type.getEntity().getDefinition() instanceof RankDefinition)
		{
			final RankDefinition rankDef = (RankDefinition) type.getEntity().getDefinition();
			if (rankDef.getRank() != "genus")
				throw new CommandException("Type must be a genus, not a " + rankDef.getRank() + ".");
			final String rank = rankName();
			checkRank(rank);
			checkType(type, rank);
		}
		else
			throw new CommandException("Type must be a genus, not a taxon which is not rank-defined.");
		return createSingleton(type);
	}
}
