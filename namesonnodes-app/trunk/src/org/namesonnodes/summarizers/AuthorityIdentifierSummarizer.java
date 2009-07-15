package org.namesonnodes.summarizers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.summaries.SummaryItem;
import org.xml.sax.SAXException;

public final class AuthorityIdentifierSummarizer implements Summarizer<AuthorityIdentifier>
{
	public List<SummaryItem> summarize(final Collection<AuthorityIdentifier> entities)
	{
		final List<SummaryItem> data = new ArrayList<SummaryItem>();
		for (final AuthorityIdentifier identifier : entities)
		{
			final String text = identifier.getEntity().getLabel().toHTMLText();
			try
			{
				final SummaryItem item = new SummaryItem(identifier.getId(), text, "AuthorityIdentifier");
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
