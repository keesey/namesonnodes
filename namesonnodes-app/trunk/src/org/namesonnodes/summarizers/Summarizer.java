package org.namesonnodes.summarizers;

import java.util.Collection;
import java.util.List;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.summaries.SummaryItem;

public interface Summarizer<E extends Persistent>
{
	public List<SummaryItem> summarize(final Collection<E> entities);
}
