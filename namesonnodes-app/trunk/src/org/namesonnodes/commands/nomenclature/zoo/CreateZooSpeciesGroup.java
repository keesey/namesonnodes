package org.namesonnodes.commands.nomenclature.zoo;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.wrap.WrapSet;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateZooSpeciesGroup extends CreateZooGroup<Set<TaxonIdentifier>>
{
	private static final long serialVersionUID = 6951160626284010265L;
	public CreateZooSpeciesGroup()
	{
		super();
	}
	public CreateZooSpeciesGroup(final String baseName)
	{
		super(baseName, new WrapSet<TaxonIdentifier>(new HashSet<TaxonIdentifier>()));
	}
	public CreateZooSpeciesGroup(final String baseName, final Command<Set<TaxonIdentifier>> typeCommand)
	{
		super(baseName, typeCommand);
	}
	public CreateZooSpeciesGroup(final String baseName, final Command<Set<TaxonIdentifier>> typeCommand,
	        final Command<Taxon> taxonCommand)
	{
		super(baseName, typeCommand, taxonCommand);
	}
	@Override
	protected String baseNamePattern()
	{
		return "^[A-Z][a-z]+ [a-z]{2,}$";
	}
	@Override
	protected String baseRank()
	{
		return "species";
	}
	@Override
	protected void checkExistingTypes(final TaxonIdentifier name, final String rank, final Set<TaxonIdentifier> types)
	        throws CommandException
	{
		final RankDefinition def = (RankDefinition) name.getEntity().getDefinition();
		if (!def.getTypes().equals(types))
			throw new CommandException("Zoological species name was already defined with different types.");
	}
	@Override
	protected void checkType(final Set<TaxonIdentifier> types, final Session session) throws CommandException
	{
		for (final TaxonIdentifier type : types)
			if (type.getEntity().getDefinition() != null)
				throw new CommandException("Taxon identifier does not appear to refer to a specimen: "
				        + type.toString());
	}
	@Override
	protected Set<TaxonIdentifier> convertTypes(final Set<TaxonIdentifier> type) throws CommandException
	{
		return new HashSet<TaxonIdentifier>(type);
	}
	@Override
	protected List<TaxonIdentifier> createNames(final Session session, final AuthorityIdentifier code,
	        final Set<TaxonIdentifier> types) throws CommandException
	{
		final String[] parts = baseName.split(" ");
		final String genusName = parts[0];
		final String genusAbbr = genusName.substring(0, 1) + ".";
		final String epithet = parts[1];
		final String epithetAbbr = epithet.substring(0, 1) + ".";
		final List<TaxonIdentifier> names = new ArrayList<TaxonIdentifier>();
		names.add(defineName(genusName + " (" + epithet + ")", genusAbbr + " (" + epithet + ")", "superspecies", 1.05,
		        types, code, session));
		names.add(defineName(baseName, genusAbbr + " " + epithet, "species", 1.0, types, code, session));
		names.add(defineName(baseName + " " + epithet, genusAbbr + " " + epithetAbbr + " " + epithet, "subspecies",
		        0.95, types, code, session));
		return names;
	}
	@Override
	protected boolean italics()
	{
		return true;
	}
}
