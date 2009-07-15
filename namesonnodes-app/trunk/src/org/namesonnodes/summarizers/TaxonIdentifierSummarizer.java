package org.namesonnodes.summarizers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.xml.sax.SAXException;

public final class TaxonIdentifierSummarizer implements Summarizer<TaxonIdentifier>
{
	public List<SummaryItem> summarize(final Collection<TaxonIdentifier> entities)
	{
		final List<SummaryItem> data = new ArrayList<SummaryItem>();
		for (final TaxonIdentifier identifier : entities)
		{
			final String text = identifier.getLabel().toHTMLText() + " ("
			        + identifier.getAuthority().getEntity().getLabel().toShortHTMLText() + ")";
			try
			{
				final SummaryItem item = new SummaryItem(identifier.getId(), text, "TaxonIdentifier");
				data.add(item);
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
		}
		return data;
	}
}
