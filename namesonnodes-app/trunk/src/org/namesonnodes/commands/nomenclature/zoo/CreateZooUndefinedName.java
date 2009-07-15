package org.namesonnodes.commands.nomenclature.zoo;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.CreateUndefinedName;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateZooUndefinedName extends AbstractCommand<TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5380477005060683076L;
	private final CreateUndefinedName createUndefinedName = new CreateUndefinedName();
	public CreateZooUndefinedName()
	{
		super();
		createUndefinedName.setAllowExisting(true);
		createUndefinedName.setAuthorityCommand(new ZoologicalCode());
		createUndefinedName.setItalics(false);
	}
	public CreateZooUndefinedName(final String name)
	{
		this();
		createUndefinedName.setName(name);
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
		if (getName() != null && !getName().matches("^[A-Z][a-z]+$"))
			throw new CommandException("Invalid zoological name.");
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
