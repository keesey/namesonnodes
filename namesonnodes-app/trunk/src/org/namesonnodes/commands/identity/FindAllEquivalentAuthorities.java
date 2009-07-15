package org.namesonnodes.commands.identity;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;

public final class FindAllEquivalentAuthorities extends AbstractCommand<Set<AuthorityIdentifier>>
{
	private static final long serialVersionUID = 5007233087920021013L;
	private Command<? extends Collection<Authority>> entitiesCommand;
	public FindAllEquivalentAuthorities()
	{
		super();
	}
	public FindAllEquivalentAuthorities(final Command<? extends Collection<Authority>> entitiesCommand)
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
	protected Set<AuthorityIdentifier> doExecute(final Session session) throws CommandException
	{
		final Collection<Authority> authorities = acquire(entitiesCommand, session, "entities");
		final Set<AuthorityIdentifier> identifiers = new HashSet<AuthorityIdentifier>();
		for (final Authority authority : authorities)
		{
			final FindEquivalentAuthorities find = new FindEquivalentAuthorities();
			find.setEntityCommand(new WrapEntity<Authority>(authority));
			identifiers.addAll(find.execute(session));
		}
		return identifiers;
	}
	public Command<? extends Collection<Authority>> getEntitiesCommand()
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
	public void setEntitiesCommand(final Command<? extends Collection<Authority>> entitiesCommand)
	{
		this.entitiesCommand = entitiesCommand;
	}
}
