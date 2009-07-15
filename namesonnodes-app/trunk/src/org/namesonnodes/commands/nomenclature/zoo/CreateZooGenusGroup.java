package org.namesonnodes.commands.nomenclature.zoo;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateZooGenusGroup extends CreateZooHigherGroup
{
	private static final long serialVersionUID = -7454068365511697748L;
	@Override
	protected String baseNamePattern()
	{
		return "^[A-Z][a-z]+$";
	}
	@Override
	protected String baseRank()
	{
		return "genus";
	}
	@Override
	protected void checkTypeName(final String typeName) throws CommandException
	{
		if (!typeName.matches("^" + baseName + " [a-z]{2,}$"))
			throw new CommandException("Species \"" + typeName + "\" cannot be the type of genus \"" + baseName + "\".");
	}
	@Override
	protected List<TaxonIdentifier> createNames(final Session session, final AuthorityIdentifier code,
	        final Set<TaxonIdentifier> type) throws CommandException
	{
		final List<TaxonIdentifier> names = new ArrayList<TaxonIdentifier>();
		names.add(defineName(baseName, null, "genus", 2.0, type, code, session));
		names.add(defineName(baseName + " (" + baseName + ")", baseName.substring(0, 1) + ". (" + baseName + ")",
		        "subgenus", 1.95, type, code, session));
		return names;
	}
	@Override
	protected boolean italics()
	{
		return true;
	}
	@Override
	protected String typeRank()
	{
		return "species";
	}
}
