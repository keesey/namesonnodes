package org.namesonnodes.commands.search;

import static org.hibernate.criterion.Restrictions.eq;
import static org.hibernate.criterion.Restrictions.ilike;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class EpithetSearch extends AbstractCommand<List<TaxonIdentifier>>
{
	private static final long serialVersionUID = -689093999608537655L;
	private String epithet;
	public String getEpithet()
    {
    	return epithet;
    }
	public void setEpithet(String epithet)
    {
    	this.epithet = epithet;
    }
	public Command<AuthorityIdentifier> getAuthorityCommand()
    {
    	return authorityCommand;
    }
	public void setAuthorityCommand(Command<AuthorityIdentifier> authorityCommand)
    {
    	this.authorityCommand = authorityCommand;
    }
	private Command<AuthorityIdentifier> authorityCommand;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "epithet", "authority" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { epithet, authorityCommand };
		return v;
	}
	@Override
	protected List<TaxonIdentifier> doExecute(final Session session) throws CommandException
	{
		if (epithet == null || epithet.length() == 0)
			throw new CommandException("No epithet specified.");
		final Criteria criteria = session.createCriteria(TaxonIdentifier.class);
		final int l = epithet.length();
		final String namePattern = "% %" + (l > 2 ? epithet.substring(0, l - 2) + "%" : epithet);
		criteria.add(ilike("label.name", namePattern));
		if (authorityCommand != null)
		{
			final AuthorityIdentifier authority = acquire(authorityCommand, session, "authority");
			criteria.add(eq("authority", authority));
		}
		final List<TaxonIdentifier> identifiers = new ArrayList<TaxonIdentifier>();
		for (final Object result : criteria.list())
			identifiers.add((TaxonIdentifier) result);
		return identifiers;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
}
