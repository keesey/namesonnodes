package org.namesonnodes.summarizers;

import static org.namesonnodes.utils.CollectionUtil.join;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import javax.xml.parsers.ParserConfigurationException;
import org.hibernate.Session;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.identity.FindEquivalentEntities;
import org.namesonnodes.commands.identity.FindEquivalentTaxa;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.namesonnodes.utils.DocumentUtil;
import org.xml.sax.SAXException;

public final class TaxonSummarizer implements Summarizer<Taxon>
{
	final Session session;
	public TaxonSummarizer(final Session session)
	{
		super();
		this.session = session;
	}
	public List<SummaryItem> summarize(final Collection<Taxon> entities)
	{
		final List<SummaryItem> data = new ArrayList<SummaryItem>();
		for (final Taxon taxon : entities)
		{
			final SummaryItem item = new SummaryItem(taxon.getId());
			item.setClassName("Taxon");
			final FindEquivalentEntities<Taxon, TaxonIdentifier> findEquivalentTaxa = new FindEquivalentTaxa(
			        new WrapEntity<Taxon>(taxon));
			try
			{
				Set<TaxonIdentifier> identifiers;
				try
				{
					identifiers = findEquivalentTaxa.execute(session);
				}
				catch (final CommandException ex)
				{
					item.setTextHTML(DocumentUtil.read("[error: " + ex.getMessage().replaceAll("<", "&lt;") + "]"));
					data.add(item);
					continue;
				}
				final SortedSet<String> names = new TreeSet<String>();
				for (final TaxonIdentifier identifier : identifiers)
				{
					final String name = identifier.getLabel().toHTMLText() + " ("
					        + identifier.getAuthority().getEntity().getLabel().toShortHTMLText() + ")";
					names.add(name);
				}
				item.setTextHTML(DocumentUtil.read("<span>" + join(names, "; ") + "</span>"));
			}
			catch (final IOException ex)
			{
				throw new RuntimeException(ex);
			}
			catch (final ParserConfigurationException ex)
			{
				throw new RuntimeException(ex);
			}
			catch (final SAXException ex)
			{
				throw new RuntimeException(ex);
			}
			data.add(item);
		}
		return data;
	}
}
