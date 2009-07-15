package org.namesonnodes.commands.search;

import java.util.HashSet;
import java.util.Set;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Junction;
import org.hibernate.criterion.Restrictions;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Labelled;

public final class LabelSearch<L extends Labelled> extends AbstractCommand<Set<L>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 3980618070995304979L;
	private boolean caseSensitive = true;
	private final Class<L> entityClass;
	private boolean fullLength = true;
	private String name;
	public LabelSearch(final Class<L> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "caseSensitive" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { name, caseSensitive };
		return v;
	}
	@Override
	protected Set<L> doExecute(final Session session) throws CommandException
	{
		if (name == null || name.length() <= 1)
			return new HashSet<L>();
		final Criteria criteria = session.createCriteria(entityClass);
		final Junction or = Restrictions.disjunction();
		if (fullLength)
		{
			if (caseSensitive)
			{
				or.add(Restrictions.eq("label.name", name));
				or.add(Restrictions.eq("label.abbr", name));
			}
			else
			{
				or.add(Restrictions.ilike("label.name", name));
				or.add(Restrictions.ilike("label.abbr", name));
			}
		}
		else if (caseSensitive)
		{
			or.add(Restrictions.like("label.name", name + "%"));
			or.add(Restrictions.like("label.abbr", name + "%"));
		}
		else
		{
			or.add(Restrictions.ilike("label.name", name + "%"));
			or.add(Restrictions.ilike("label.abbr", name + "%"));
		}
		criteria.add(or);
		final Set<L> results = new HashSet<L>();
		for (final Object result : criteria.list())
			results.add(entityClass.cast(result));
		return results;
	}
	public final boolean getCaseSensitive()
	{
		return caseSensitive;
	}
	public final boolean getFullLength()
	{
		return fullLength;
	}
	public final String getName()
	{
		return name;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setCaseSensitive(final boolean caseSensitive)
	{
		this.caseSensitive = caseSensitive;
	}
	public final void setFullLength(final boolean fullLength)
	{
		this.fullLength = fullLength;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
}
