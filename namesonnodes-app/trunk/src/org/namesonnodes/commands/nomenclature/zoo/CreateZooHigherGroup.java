package org.namesonnodes.commands.nomenclature.zoo;

import static org.namesonnodes.utils.CollectionUtil.createSingleton;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public abstract class CreateZooHigherGroup extends CreateZooGroup<TaxonIdentifier>
{
	private static final long serialVersionUID = 782954265846708718L;
	public CreateZooHigherGroup()
	{
		super();
	}
	public CreateZooHigherGroup(final String baseName, final Command<TaxonIdentifier> typeCommand)
	{
		super(baseName, typeCommand);
	}
	@Override
	protected void checkExistingTypes(final TaxonIdentifier name, final String rank, final Set<TaxonIdentifier> types)
	        throws CommandException
	{
		final RankDefinition def = (RankDefinition) name.getEntity().getDefinition();
		if (def.getTypes().size() != 1)
			throw new CommandException("Zoological " + rank + " name \"" + name.getLabel().getName()
			        + "\" was given a possibly invalid definition.");
		final TaxonIdentifier type = types.iterator().next();
		if (!def.getTypes().iterator().next().equals(type))
			throw new CommandException("Zoological " + rank + " name \"" + name.getLabel().getName()
			        + "\" was already defined with a different type " + typeRank() + ".");
	}
	@Override
	protected void checkType(final Set<TaxonIdentifier> types, final Session session) throws CommandException
	{
		if (types.size() != 1)
			throw new CommandException("Invalid number of types: " + types.size() + ". (Expected 1.)");
		final TaxonIdentifier type = types.iterator().next();
		checkTypeName(type.getLabel().getName());
		final RankDefinition typeDef = (RankDefinition) type.getEntity().getDefinition();
		if (typeDef == null)
			throw new CommandException("Type " + typeRank() + " (" + type.getLabel().getName()
			        + ") is not rank-defined.");
		if (!typeDef.getRank().equals(typeRank()))
			throw new CommandException("Type " + typeRank() + " (" + type.getLabel().getName()
			        + ") has a different rank: " + typeDef.getRank() + ".");
	}
	protected abstract void checkTypeName(String typeName) throws CommandException;
	@Override
	protected Set<TaxonIdentifier> convertTypes(final TaxonIdentifier type) throws CommandException
	{
		return createSingleton(type);
	}
	protected abstract String typeRank();
}