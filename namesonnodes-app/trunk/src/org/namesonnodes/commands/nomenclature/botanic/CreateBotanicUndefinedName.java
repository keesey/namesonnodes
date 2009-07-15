package org.namesonnodes.commands.nomenclature.botanic;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.CreateUndefinedName;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateBotanicUndefinedName extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = -3577762742430694391L;
	private final CreateUndefinedName createUndefinedName = new CreateUndefinedName();
	public CreateBotanicUndefinedName()
	{
		super();
		createUndefinedName.setAllowExisting(true);
		createUndefinedName.setAuthorityCommand(new BotanicalCode());
		createUndefinedName.setItalics(true);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getName() };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (getName() != null && !getName().matches("^[A-Z][a-z]+(-[a-z]+)?$"))
			throw new CommandException("Invalid botanical name.");
		return createUndefinedName.execute(session);
	}
	public final String getName()
	{
		return createUndefinedName.getName();
	}
	public boolean readOnly()
	{
		return createUndefinedName.readOnly();
	}
	public boolean requiresCommit()
	{
		return createUndefinedName.requiresCommit();
	}
	public final void setName(final String name)
	{
		createUndefinedName.setName(name);
	}
}
