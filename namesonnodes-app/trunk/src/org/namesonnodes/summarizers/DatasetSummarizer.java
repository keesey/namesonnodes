package org.namesonnodes.summarizers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.xml.sax.SAXException;

public final class DatasetSummarizer implements Summarizer<Dataset>
{
	public List<SummaryItem> summarize(final Collection<Dataset> entities)
	{
		final List<SummaryItem> data = new ArrayList<SummaryItem>();
		for (final Dataset dataset : entities)
		{
			final String text = dataset.getLabel().toHTMLText() + " ("
			        + dataset.getAuthority().getEntity().getLabel().toShortHTMLText() + ")";
			try
			{
				final SummaryItem item = new SummaryItem(dataset.getId(), text, "Dataset");
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
