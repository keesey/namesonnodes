package org.namesonnodes.commands.nomenclature.zoo;

import static org.namesonnodes.utils.URIUtil.escape;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateZooFamilyGroup extends CreateZooHigherGroup
{
	private static final long serialVersionUID = -2536880190648582889L;
	public CreateZooFamilyGroup()
	{
		super();
	}
	public CreateZooFamilyGroup(final String baseName)
	{
		super(baseName, null);
	}
	public CreateZooFamilyGroup(final String baseName, final Command<TaxonIdentifier> typeCommand)
	{
		super(baseName, typeCommand);
	}
	public CreateZooFamilyGroup(final String baseName, final String typeGenusName)
	{
		super(baseName, new ResolveTaxonIdentifier(ZoologicalCode.URI, escape(typeGenusName)));
	}
	@Override
	protected String baseNamePattern()
	{
		return "^[A-Z][a-z]*idae$";
	}
	@Override
	protected String baseRank()
	{
		return "family";
	}
	@Override
	protected void checkTypeName(final String typeName) throws CommandException
	{
		final String root = findRoot();
		final int leeway = root.length() < 2 ? 0 : root.length() < 3 ? 1 : 2;
		if (!typeName.startsWith(root.substring(0, root.length() - leeway)))
			throw new CommandException("Zoological " + baseRank() + " name \"" + baseName
			        + "\" does not appear to be derived from type " + typeRank() + " name \"" + typeName + "\".");
	}
	@Override
	protected List<TaxonIdentifier> createNames(final Session session, final AuthorityIdentifier code,
	        final Set<TaxonIdentifier> types) throws CommandException
	{
		final String root = findRoot();
		final List<TaxonIdentifier> names = new ArrayList<TaxonIdentifier>();
		names.add(defineName(root + "oidea", null, "superfamily", 3.05, types, code, session));
		names.add(defineName(baseName, null, "family", 3.0, types, code, session));
		names.add(defineName(root + "inae", null, "subfamily", 2.95, types, code, session));
		names.add(defineName(root + "ini", null, "tribe", 2.9, types, code, session));
		names.add(defineName(root + "ina", null, "subtribe", 2.85, types, code, session));
		return names;
	}
	private String findRoot()
	{
		return baseName.substring(0, baseName.length() - 4);
	}
	@Override
	protected boolean italics()
	{
		return false;
	}
	@Override
	protected String typeRank()
	{
		return "genus";
	}
}
