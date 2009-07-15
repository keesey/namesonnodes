package org.namesonnodes.commands.search;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Labelled;

public class FullLabelSearch<L extends Labelled> extends AbstractCommand<List<L>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 7945031987301793282L;
	private final Class<L> entityClass;
	private int targetLength = 16;
	private String text;
	public FullLabelSearch(final Class<L> entityClass)
	{
		super();
		this.entityClass = entityClass;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "text", "targetLength" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { text, targetLength };
		return v;
	}
	@Override
	protected List<L> doExecute(final Session session) throws CommandException
	{
		final List<L> list = new ArrayList<L>();
		final LabelSearch<L> labelSearch = new LabelSearch<L>(entityClass);
		Set<L> searchResults;
		labelSearch.setName(text);
		labelSearch.setCaseSensitive(true);
		labelSearch.setFullLength(true);
		// Find exact match, case-sensitive.
		list.addAll(labelSearch.execute(session));
		// Find exact match, case-insensitive.
		if (list.size() < targetLength)
		{
			labelSearch.clearResult();
			labelSearch.setCaseSensitive(false);
			searchResults = labelSearch.execute(session);
			searchResults.removeAll(list);
			list.addAll(searchResults);
			// Find leading match, case-sensitive.
			if (list.size() < targetLength)
			{
				labelSearch.clearResult();
				labelSearch.setCaseSensitive(true);
				labelSearch.setFullLength(false);
				searchResults = labelSearch.execute(session);
				searchResults.removeAll(list);
				list.addAll(searchResults);
				// Find leading match, case-insensitive.
				if (list.size() < targetLength)
				{
					labelSearch.clearResult();
					labelSearch.setCaseSensitive(false);
					searchResults = labelSearch.execute(session);
					searchResults.removeAll(list);
					list.addAll(searchResults);
				}
			}
		}
		return list;
	}
	public final int getTargetLength()
	{
		return targetLength;
	}
	public final String getText()
	{
		return text;
	}
	public boolean readOnly()
	{
		return true;
	}
	public boolean requiresCommit()
	{
		return false;
	}
	public final void setTargetLength(final int targetLength)
	{
		this.targetLength = targetLength;
	}
	public final void setText(final String text)
	{
		this.text = text;
	}
}
