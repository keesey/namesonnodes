package org.namesonnodes.summarizers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.xml.sax.SAXException;

public final class AuthoritySummarizer implements Summarizer<Authority>
{
	public List<SummaryItem> summarize(final Collection<Authority> entities)
	{
		final List<SummaryItem> data = new ArrayList<SummaryItem>();
		for (final Authority entity : entities)
		{
			final String text = entity.getLabel().toHTMLText();
			try
			{
				final SummaryItem item = new SummaryItem(entity.getId(), text, "Authority");
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
