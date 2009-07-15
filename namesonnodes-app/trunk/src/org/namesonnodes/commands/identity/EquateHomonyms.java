package org.namesonnodes.commands.identity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.Labelled;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class EquateHomonyms extends AbstractCommand<Set<Set<TaxonIdentifier>>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5800384894688656500L;
	protected static String cleanName(final Labelled labelled)
	{
		return labelled.getLabel().getName().toLowerCase().replaceAll("[^a-z0-9]", " ").replaceAll("\\s+", " ").trim();
	}
	protected static boolean isAvailable(final Labelled labelled)
	{
		return labelled.getLabel().getName().matches(".*[A-Za-z]{2,}.*");
	}
	private boolean commitRequired;
	private Command<? extends Collection<Authority>> authoritiesCommand;
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "authorities" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { authoritiesCommand };
		return v;
	}
	@Override
	protected Set<Set<TaxonIdentifier>> doExecute(final Session session) throws CommandException
	{
		final List<Authority> authorities = new ArrayList<Authority>(new HashSet<Authority>(acquire(authoritiesCommand,
		        session, "authorities")));
		final Map<Authority, Set<TaxonIdentifier>> entityMap = new HashMap<Authority, Set<TaxonIdentifier>>();
		final List<EquateTaxa> equates = new ArrayList<EquateTaxa>();
		final int n = authorities.size();
		for (int i = 0; i < n - 1; ++i)
		{
			final Authority a = authorities.get(i);
			final Set<TaxonIdentifier> aTaxa = findTaxa(a, entityMap, session);
			if (aTaxa.isEmpty())
				continue;
			for (int j = i + 1; j < n; ++j)
			{
				final Authority b = authorities.get(j);
				final Set<TaxonIdentifier> bTaxa = findTaxa(b, entityMap, session);
				if (bTaxa.isEmpty())
					continue;
				for (final TaxonIdentifier aTaxon : aTaxa)
				{
					if (!isAvailable(aTaxon))
						continue;
					for (final TaxonIdentifier bTaxon : bTaxa)
					{
						if (!isAvailable(bTaxon))
							continue;
						if (aTaxon.getEntity() != bTaxon.getEntity() && cleanName(aTaxon).equals(cleanName(bTaxon)))
							equates.add(new EquateTaxa(aTaxon.getEntity(), bTaxon.getEntity()));
					}
				}
			}
		}
		final Set<Set<TaxonIdentifier>> results = new HashSet<Set<TaxonIdentifier>>();
		for (final EquateTaxa equate : equates)
		{
			results.add(equate.execute(session));
			commitRequired = commitRequired || equate.requiresCommit();
		}
		return results;
	}
	private Set<TaxonIdentifier> findTaxa(final Authority authority,
	        final Map<Authority, Set<TaxonIdentifier>> entityMap, final Session session)
	{
		if (entityMap.containsKey(authority))
			return entityMap.get(authority);
		final Set<TaxonIdentifier> taxa = new HashSet<TaxonIdentifier>();
		for (final Object result : session.createCriteria(TaxonIdentifier.class).createCriteria("authority").add(
		        Restrictions.eq("entity", authority)).list())
			taxa.add((TaxonIdentifier) result);
		entityMap.put(authority, taxa);
		return taxa;
	}
	public final Command<? extends Collection<Authority>> getAuthoritiesCommand()
	{
		return authoritiesCommand;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(authoritiesCommand);
	}
	public final void setAuthoritiesCommand(final Command<? extends Collection<Authority>> authoritiesCommand)
	{
		this.authoritiesCommand = authoritiesCommand;
	}
}
