package org.namesonnodes.commands.user;

import static org.namesonnodes.commands.user.UserUtil.sessionUserAccount;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.users.UserAccount;

public final class UpdateUserDataset extends AbstractCommand<Object>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 365756891583361244L;
	private boolean commitRequired;
	private Dataset dataset;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "dataset" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getDataset() };
		return v;
	}
	@Override
	protected Object doExecute(final Session session) throws CommandException
	{
		if (dataset == null)
			throw new CommandException("No dataset.");
		final UserAccount account = sessionUserAccount(session);
		if (account == null)
			throw new CommandException("You must log in to perform this task.");
		if (dataset.getAuthority().getId() != account.getAuthority().getId())
			throw new CommandException("This is not your dataset.");
		session.merge(dataset);
		commitRequired = true;
		return null;
	}
	public Dataset getDataset()
	{
		return dataset;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	public void setDataset(final Dataset dataset)
	{
		this.dataset = dataset;
	}
}
