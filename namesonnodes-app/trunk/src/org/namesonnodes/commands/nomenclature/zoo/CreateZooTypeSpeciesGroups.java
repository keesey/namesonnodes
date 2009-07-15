package org.namesonnodes.commands.nomenclature.zoo;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.collections.ExtractElement;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateZooTypeSpeciesGroups extends AbstractCommand<List<List<TaxonIdentifier>>>
{
	private static final long serialVersionUID = 5153971390493680001L;
	private final CreateZooGenusGroup createZooGenusGroup = new CreateZooGenusGroup();
	private final CreateZooSpeciesGroup createZooSpeciesGroup = new CreateZooSpeciesGroup();
	public CreateZooTypeSpeciesGroups()
	{
		super();
	}
	public CreateZooTypeSpeciesGroups(final String speciesName)
	{
		super();
		setSpeciesName(speciesName);
	}
	public CreateZooTypeSpeciesGroups(final String speciesName, final Command<Taxon> speciesCommand)
	{
		this(speciesName);
		setSpeciesCommand(speciesCommand);
	}
	public CreateZooTypeSpeciesGroups(final String speciesName, final Command<Taxon> speciesCommand,
	        final Command<Set<TaxonIdentifier>> typeSpecimensCommand)
	{
		this(speciesName, speciesCommand);
		setTypeSpecimensCommand(typeSpecimensCommand);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "speciesName", "species", "typeSpecimens" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getSpeciesName(), getSpeciesCommand(), getTypeSpecimensCommand() };
		return v;
	}
	@Override
	public void clearResult()
	{
		super.clearResult();
		createZooGenusGroup.clearResult();
		createZooSpeciesGroup.clearResult();
	}
	@Override
	protected List<List<TaxonIdentifier>> doExecute(final Session session) throws CommandException
	{
		final List<List<TaxonIdentifier>> groups = new ArrayList<List<TaxonIdentifier>>();
		groups.add(createZooSpeciesGroup.execute(session));
		createZooGenusGroup.setTypeCommand(new ExtractElement<TaxonIdentifier>(createZooSpeciesGroup, 1));
		groups.add(0, createZooGenusGroup.execute(session));
		return groups;
	}
	public final Command<Taxon> getSpeciesCommand()
	{
		return createZooSpeciesGroup.getTaxonCommand();
	}
	public String getSpeciesName()
	{
		return createZooSpeciesGroup.getBaseName();
	}
	public final Command<Set<TaxonIdentifier>> getTypeSpecimensCommand()
	{
		return createZooSpeciesGroup.getTypeCommand();
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return createZooSpeciesGroup.requiresCommit() || createZooGenusGroup.requiresCommit();
	}
	public final void setSpeciesCommand(final Command<Taxon> taxonCommand)
	{
		createZooSpeciesGroup.setTaxonCommand(taxonCommand);
	}
	public void setSpeciesName(final String speciesName)
	{
		createZooSpeciesGroup.setBaseName(speciesName);
		if (speciesName != null)
		{
			final String[] parts = speciesName.split(" ");
			if (parts.length == 2)
			{
				createZooGenusGroup.setBaseName(parts[0]);
				return;
			}
		}
		createZooGenusGroup.setBaseName(null);
	}
	public final void setTypeSpecimensCommand(final Command<Set<TaxonIdentifier>> typeCommand)
	{
		createZooSpeciesGroup.setTypeCommand(typeCommand);
	}
}
