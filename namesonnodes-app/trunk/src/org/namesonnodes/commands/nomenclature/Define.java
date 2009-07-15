package org.namesonnodes.commands.nomenclature;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Definition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public abstract class Define<D extends Definition> extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = -231047517060636593L;
	protected Command<AuthorityIdentifier> authorityCommand;
	protected boolean commitRequired = false;
	protected Command<TaxonIdentifier> identifierCommand;
	public Define()
	{
		super();
	}
	protected final TaxonIdentifier acquireIdentifier(final Session session) throws CommandException
	{
		final TaxonIdentifier identifier = acquire(identifierCommand, session, "identifier");
		if (authorityCommand == null)
			return identifier;
		final AuthorityIdentifier authority = acquire(authorityCommand, session, "authority");
		if (authority == identifier.getAuthority())
			return identifier;
		TaxonIdentifier newIdentifier = new ResolveTaxonIdentifier(authority.getUri(), identifier.getLocalName())
		        .execute(session);
		if (newIdentifier == null)
			newIdentifier = new TaxonIdentifier(identifier, authority);
		return newIdentifier;
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return authorityCommand;
	}
	public final Command<TaxonIdentifier> getIdentifierCommand()
	{
		return identifierCommand;
	}
	public final boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(authorityCommand) || commandRequiresCommit(identifierCommand);
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		this.authorityCommand = authorityCommand;
	}
	public final void setIdentifierCommand(final Command<TaxonIdentifier> identifierCommand)
	{
		this.identifierCommand = identifierCommand;
	}
}