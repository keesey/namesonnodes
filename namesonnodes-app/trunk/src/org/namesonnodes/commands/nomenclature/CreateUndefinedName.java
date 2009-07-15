package org.namesonnodes.commands.nomenclature;

import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.utils.URIUtil.escape;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateUndefinedName extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = -708275322123337060L;
	private boolean allowExisting = true;
	protected Command<AuthorityIdentifier> authorityCommand;
	private boolean commitRequired = false;
	protected Command<Taxon> entityCommand;
	private boolean italics = true;
	private String localName;
	private String name;
	private final String namePattern;
	public CreateUndefinedName()
	{
		this(null);
	}
	public CreateUndefinedName(final String namePattern)
	{
		super();
		this.namePattern = namePattern == null ? "^[^\\s]+( [^\\s])*$" : namePattern;
	}
	public CreateUndefinedName(final String name, final Command<AuthorityIdentifier> authorityCommand)
	{
		this(name, authorityCommand, false, true);
	}
	public CreateUndefinedName(final String name, final Command<AuthorityIdentifier> authorityCommand,
	        final boolean italics)
	{
		this(name, authorityCommand, italics, true);
	}
	public CreateUndefinedName(final String name, final Command<AuthorityIdentifier> authorityCommand,
	        final boolean italics, final boolean allowExisting)
	{
		this(null);
		this.name = name;
		this.authorityCommand = authorityCommand;
		this.italics = italics;
		this.allowExisting = allowExisting;
	}
	public CreateUndefinedName(final String name, final Command<AuthorityIdentifier> authorityCommand,
	        final boolean italics, final boolean allowExisting, final Command<Taxon> taxonCommand)
	{
		this(name, authorityCommand, italics, allowExisting);
		this.entityCommand = taxonCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "name", "authority", "italics", "allowExisting", "taxon" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, authorityCommand, italics, allowExisting, entityCommand };
		return v;
	}
	@Override
	protected final TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (name == null || name.length() == 0)
			throw new CommandException("No name set.");
		if (namePattern != null && !name.matches(namePattern))
			throw new CommandException("Invalid name.");
		if (authorityCommand == null)
			throw new CommandException("No authority specified.");
		final AuthorityIdentifier authorityIdentifier = authorityCommand.execute(session);
		if (authorityIdentifier == null)
			throw new CommandException("Cannot find authority: " + authorityCommand.toCommandString());
		final String localName = this.localName == null || this.localName == "" ? escape(name) : this.localName;
		if (allowExisting)
		{
			String qName;
			qName = authorityIdentifier.getUri() + "::" + localName;
			final TaxonIdentifier existingIdentifier = (TaxonIdentifier) session.createCriteria(TaxonIdentifier.class)
			        .add(eq("QName", qName)).uniqueResult();
			if (existingIdentifier != null)
				return existingIdentifier;
		}
		final TaxonIdentifier taxonIdentifier = new TaxonIdentifier();
		taxonIdentifier.setAuthority(authorityIdentifier);
		if (entityCommand == null)
			taxonIdentifier.setEntity(new Taxon());
		else
			taxonIdentifier.setEntity(acquire(entityCommand, session, "taxon"));
		taxonIdentifier.setLocalName(localName);
		taxonIdentifier.getLabel().setName(name);
		taxonIdentifier.getLabel().setItalics(italics);
		session.save(taxonIdentifier);
		commitRequired = true;
		return taxonIdentifier;
	}
	public final boolean getAllowExisting()
	{
		return allowExisting;
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return authorityCommand;
	}
	public final Command<Taxon> getEntityCommand()
	{
		return entityCommand;
	}
	public final boolean getItalics()
	{
		return italics;
	}
	public String getLocalName()
	{
		return localName;
	}
	public final String getName()
	{
		return name;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(authorityCommand);
	}
	public final void setAllowExisting(final boolean allowExisting)
	{
		this.allowExisting = allowExisting;
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		this.authorityCommand = authorityCommand;
	}
	public final void setEntityCommand(final Command<Taxon> entityCommand)
	{
		this.entityCommand = entityCommand;
	}
	public final void setItalics(final boolean italics)
	{
		this.italics = italics;
	}
	public void setLocalName(final String localName)
	{
		this.localName = localName;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
}
