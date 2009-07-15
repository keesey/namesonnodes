package org.namesonnodes.commands.nomenclature.botanic;

import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getLevel;
import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getPattern;
import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getRankNameFromTaxonName;
import static org.namesonnodes.utils.CollectionUtil.createSingleton;
import static org.namesonnodes.utils.URIUtil.escape;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicSubgenericName extends CreateBotanicName
{
	private static final long serialVersionUID = 7447074705990972835L;
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
	private void checkGenericDefinition(final TaxonIdentifier type, final Session session, final String genericName)
	        throws CommandException
	{
		final TaxonIdentifier genus = new ResolveTaxonIdentifier(BotanicalCode.URI + "::" + escape(genericName))
		        .execute(session);
		if (genus != null)
			if (genus.getEntity().getDefinition() == null)
				createGenericDefinition(type, session, genus);
			else if (genus.getEntity().getDefinition() instanceof RankDefinition)
			{
				final RankDefinition genusRankDefinition = (RankDefinition) genus.getEntity().getDefinition();
				if (genusRankDefinition.getTypes().size() != 1)
					throw new CommandException("Genus " + genus.getLabel().getName() + " has an invalid definition.");
				if (!genusRankDefinition.getTypes().iterator().next().equals(type))
					throw new CommandException("The type species of " + name + " and " + genus.getLabel().getName()
					        + " do not match.");
			}
			else
				throw new CommandException("Genus " + genus.getLabel().getName() + " has an non-rank-based definition.");
	}
	private void checkRank(final String rank) throws CommandException
	{
		final double level = getLevel(rank);
		if (level >= getLevel("genus") || level <= getLevel("species"))
			throw new CommandException(name + " does not appear to be a botanical subgeneric, supraspecific name.");
	}
	private void checkType(final TaxonIdentifier type, final String rank, final Session session)
	        throws CommandException
	{
		final Pattern pattern = Pattern.compile(getPattern(rank));
		final Matcher matcher = pattern.matcher(name);
		if (!matcher.matches())
			throw new CommandException("Invalid name for botanical " + rank + ".");
		final String genericName = matcher.group(1);
		final String subgenericName = matcher.group(2);
		if (!type.getAuthority().getUri().equals(BotanicalCode.URI))
			throw new CommandException("Type taxon must be a botanical species. Instead, the authority is <"
			        + type.getAuthority().getUri() + ">.");
		if (!type.getLabel().getName().startsWith(genericName + " "))
			throw new CommandException(name + " does not appear to be the proper name for a " + rank + " typified by "
			        + type.getLabel().getName() + ".");
		if (genericName.equals(subgenericName))
			checkGenericDefinition(type, session, genericName);
	}
	private void createGenericDefinition(final TaxonIdentifier type, final Session session, final TaxonIdentifier genus)
	{
		final RankDefinition definition = new RankDefinition();
		definition.setLevel(getLevel("genus"));
		definition.setRank("genus");
		definition.setTypes(createSingleton(type));
		// genusRankDefinition.updateInclusions();
		genus.getEntity().setDefinition(definition);
		commitRequired = true;
	}
	@Override
	protected String getIdentifierAbbr()
	{
		final String[] names = name.split(" ");
		if (names.length == 3)
			return names[0].charAt(0) + ". " + names[1] + " " + names[2];
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
		final TaxonIdentifier type = acquire(typeCommand, session, "type species");
		if (type.getEntity().getDefinition() instanceof RankDefinition)
		{
			final RankDefinition rankDef = (RankDefinition) type.getEntity().getDefinition();
			if (rankDef.getRank() != "species")
				throw new CommandException("Type must be a species, not a " + rankDef.getRank() + ".");
			final String rank = rankName();
			checkRank(rank);
			checkType(type, rank, session);
		}
		else
			throw new CommandException("Type must be a species, not a taxon which is not rank-defined.");
		return createSingleton(type);
	}
}
