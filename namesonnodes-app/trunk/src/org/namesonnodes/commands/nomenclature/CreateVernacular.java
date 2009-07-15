package org.namesonnodes.commands.nomenclature;

import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.CommandUtil;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateVernacular implements Command<TaxonIdentifier>
{
	private static final long serialVersionUID = -6341448721253796328L;
	private final CreateUndefinedName createUndefinedName = new CreateUndefinedName(".*");
	public void clearResult()
	{
		createUndefinedName.clearResult();
	}
	public final TaxonIdentifier execute(final Session session) throws CommandException
	{
		return createUndefinedName.execute(session);
	}
	public final boolean getAllowExisting()
	{
		return createUndefinedName.getAllowExisting();
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return createUndefinedName.getAuthorityCommand();
	}
	public final Command<Taxon> getEntityCommand()
	{
		return createUndefinedName.getEntityCommand();
	}
	public String getLocalName()
	{
		return createUndefinedName.getLocalName();
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
	public final void setAllowExisting(final boolean allowExisting)
	{
		createUndefinedName.setAllowExisting(allowExisting);
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		createUndefinedName.setAuthorityCommand(authorityCommand);
	}
	public final void setEntityCommand(final Command<Taxon> entityCommand)
	{
		createUndefinedName.setEntityCommand(entityCommand);
	}
	public void setLocalName(final String localName)
	{
		createUndefinedName.setLocalName(localName);
	}
	public final void setName(final String name)
	{
		createUndefinedName.setName(name);
	}
	public String toCommandString()
	{
		return CommandUtil.write("CreateVernacular", createUndefinedName.attributeNames(), createUndefinedName
		        .attributeValues());
	}
	@Override
	public String toString()
	{
		return toCommandString();
	}
}
