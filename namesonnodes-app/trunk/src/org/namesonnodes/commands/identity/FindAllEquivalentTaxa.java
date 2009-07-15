package org.namesonnodes.commands.identity;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class FindAllEquivalentTaxa extends AbstractCommand<Set<TaxonIdentifier>>
{
	private static final long serialVersionUID = -1671771100286223848L;
	private Command<? extends Collection<Taxon>> entitiesCommand;
	public FindAllEquivalentTaxa()
	{
		super();
	}
	public FindAllEquivalentTaxa(final Command<? extends Collection<Taxon>> entitiesCommand)
	{
		super();
		this.entitiesCommand = entitiesCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "entities" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { entitiesCommand };
		return v;
	}
	@Override
	protected Set<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		final Collection<Taxon> authorities = acquire(entitiesCommand, session, "entities");
		final Set<TaxonIdentifier> identifiers = new HashSet<TaxonIdentifier>();
		for (final Taxon taxon : authorities)
		{
			final FindEquivalentTaxa find = new FindEquivalentTaxa();
			find.setEntityCommand(new WrapEntity<Taxon>(taxon));
			identifiers.addAll(find.execute(session));
		}
		return identifiers;
	}
	public Command<? extends Collection<Taxon>> getEntitiesCommand()
	{
		return entitiesCommand;
	}
	public boolean readOnly()
	{
		return entitiesCommand == null || entitiesCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return entitiesCommand != null && entitiesCommand.requiresCommit();
	}
	public void setEntitiesCommand(final Command<? extends Collection<Taxon>> entitiesCommand)
	{
		this.entitiesCommand = entitiesCommand;
	}
}
