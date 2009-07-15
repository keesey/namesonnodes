package org.namesonnodes.commands.datasets;

import static org.namesonnodes.utils.URIUtil.escape;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;

public final class CreateDataset extends AbstractCommand<Dataset>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4169496422898960880L;
	private String abbr;
	private Command<AuthorityIdentifier> authorityCommand;
	private boolean commitRequired;
	private String localName;
	private String name;
	public CreateDataset()
	{
		super();
	}
	public CreateDataset(final String name, final String abbr, final Command<AuthorityIdentifier> authorityCommand)
	{
		super();
		this.name = name;
		this.abbr = abbr;
		this.authorityCommand = authorityCommand;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "abbr", "localName", "authority" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, abbr, localName, authorityCommand };
		return v;
	}
	@Override
	protected Dataset doExecute(final Session session) throws CommandException
	{
		final Dataset dataset = new Dataset();
		dataset.getLabel().setAbbr(abbr);
		dataset.setAuthority(acquire(authorityCommand, session, "authority"));
		dataset.setLocalName(localName == null ? escape(name) : localName);
		dataset.getLabel().setName(name);
		session.save(dataset);
		commitRequired = true;
		return dataset;
	}
	public final String getAbbr()
	{
		return abbr;
	}
	public final Command<AuthorityIdentifier> getAuthorityCommand()
	{
		return authorityCommand;
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
		return commitRequired;
	}
	public final void setAbbr(final String abbr)
	{
		this.abbr = abbr;
	}
	public final void setAuthorityCommand(final Command<AuthorityIdentifier> authorityCommand)
	{
		this.authorityCommand = authorityCommand;
	}
	public void setLocalName(final String localName)
	{
		if (localName == null || localName.length() == 0)
			this.localName = null;
		else
			this.localName = localName;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
}
