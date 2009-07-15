package org.namesonnodes.commands.characters;

import static org.namesonnodes.utils.URIUtil.escape;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.StateDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class CreateState extends AbstractCommand<TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 960819131729837596L;
	private Command<AuthorityIdentifier> authorityCommand;
	private String description;
	private boolean commitRequired = false;
	private Command<Taxon> entityCommand;
	private String localName;
	private String summary;
	public CreateState()
	{
		super();
	}
	public CreateState(final String description, final String summary,
	        final Command<AuthorityIdentifier> authorityCommand)
	{
		super();
		this.description = description;
		this.summary = summary;
		this.authorityCommand = authorityCommand;
	}
	public CreateState(final String description, final String summary,
	        final Command<AuthorityIdentifier> authorityCommand, final Command<Taxon> identityCommand)
	{
		this(description, summary, authorityCommand);
		this.entityCommand = identityCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "summary", "description", "authority", "identity" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { summary, description, authorityCommand, entityCommand };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		final TaxonIdentifier state = new TaxonIdentifier();
		if (summary != description)
			state.getLabel().setAbbr(summary);
		state.setAuthority(acquire(authorityCommand, session, "authority"));
		if (entityCommand == null)
		{
			final Taxon taxon = new Taxon();
			taxon.setDefinition(new StateDefinition());
			// session.merge(taxon);
			// commitRequired = true;
			state.setEntity(taxon);
		}
		else
			state.setEntity(acquire(entityCommand, session, "entity"));
		state.setLocalName(localName == null ? escape(description) : localName);
		state.getLabel().setName(description);
		session.save(state);
		commitRequired = true;
		return state;
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return authorityCommand;
	}
	public final String getDescription()
	{
		return description;
	}
	public final Command<Taxon> getIdentityCommand()
	{
		return entityCommand;
	}
	public String getLocalName()
	{
		return localName;
	}
	public final String getSummary()
	{
		return summary;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		this.authorityCommand = authorityCommand;
	}
	public final void setDescription(final String description)
	{
		this.description = description;
	}
	public final void setIdentityCommand(final Command<Taxon> entityCommand)
	{
		this.entityCommand = entityCommand;
	}
	public void setLocalName(final String localName)
	{
		if (localName == null || localName.length() == 0)
			this.localName = null;
		else
			this.localName = localName;
	}
	public final void setSummary(final String summary)
	{
		this.summary = summary;
	}
}
