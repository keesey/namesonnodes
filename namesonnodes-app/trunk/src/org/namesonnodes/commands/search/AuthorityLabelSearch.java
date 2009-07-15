package org.namesonnodes.commands.search;

import static org.hibernate.criterion.Restrictions.disjunction;
import static org.hibernate.criterion.Restrictions.ilike;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Junction;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;

public final class AuthorityLabelSearch extends AbstractCommand<Set<Authority>>
{
	private static final long serialVersionUID = -7376316873072789556L;
	private String label;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "label" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { label };
		return v;
	}
	@Override
	protected Set<Authority> doExecute(final Session session) throws CommandException
	{
		final Set<Authority> authorities = new HashSet<Authority>();
		final Criteria criteria = session.createCriteria(Authority.class);
		final Junction or = disjunction();
		or.add(ilike("label.abbr", label));
		or.add(ilike("label.name", label));
		criteria.add(or);
		final List<?> results = criteria.list();
		for (final Object result : results)
			authorities.add((Authority) result);
		return authorities;
	}
	public String getLabel()
	{
		return label;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public void setLabel(final String label)
	{
		this.label = label;
	}
}
