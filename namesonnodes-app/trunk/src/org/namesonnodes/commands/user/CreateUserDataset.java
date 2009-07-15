package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserUtil.sessionUserAccount;
import static org.namesonnodes.utils.URIUtil.escape;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Label;
import org.namesonnodes.domain.users.UserAccount;

public final class CreateUserDataset extends AbstractCommand<Dataset>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4532897666708980568L;
	private String abbr;
	private boolean commitRequired = false;
	private String name;
	public CreateUserDataset()
	{
		super();
	}
	public CreateUserDataset(final String name)
	{
		super();
		this.name = name;
	}
	public CreateUserDataset(final String name, final String abbr)
	{
		super();
		this.name = name;
		this.abbr = abbr;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "abbr" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, abbr };
		return v;
	}
	@Override
	protected Dataset doExecute(final Session session) throws CommandException
	{
		final Dataset dataset = new Dataset();
		final UserAccount account = sessionUserAccount(session);
		if (account == null)
			throw new CommandException("This action requires logging in.");
		dataset.setAuthority(account.getAuthority());
		dataset.setLabel(new Label(name, abbr));
		dataset.setLocalName("dataset:" + escape(name));
		session.save(dataset);
		commitRequired = true;
		return dataset;
	}
	public final String getAbbr()
	{
		return abbr;
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
	public final void setName(final String name)
	{
		this.name = name;
	}
}
