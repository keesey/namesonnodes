package org.namesonnodes.resolve.uris;

import static org.namesonnodes.utils.CollectionUtil.join;
import static org.namesonnodes.utils.URIUtil.escape;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import org.namesonnodes.niso.NISOException;
import org.namesonnodes.niso.sici.SICI;

public final class SICIResolver implements URIResolver
{
	public URL resolve(final URI uri)
	{
		if (uri.getScheme() == null || uri.getSchemeSpecificPart() == null)
			return null;
		if (uri.getScheme().equals("urn") && uri.getSchemeSpecificPart().startsWith("sici:"))
			try
			{
				final SICI sici = new SICI(uri.toString());
				String urlSource = "http://www.crossref.org/openurl?issn=" + escape(sici.getStandardNumber())
				        + "&date=" + escape(sici.getChronology().get(0).toChronologyString()) + "&spage="
				        + escape(sici.getLocation()) + "&title=" + escape(sici.getTitleCode());
				if (!sici.getEnumerationValues().isEmpty())
				{
					urlSource += "&volume=" + escape(join(sici.getEnumerationValues().get(0), "/"));
					if (sici.getEnumerationValues().size() > 1)
						urlSource += "&issue=" + escape(join(sici.getEnumerationValues().get(1), "/"));
				}
				return new URL(urlSource);
			}
			catch (final NISOException ex)
			{
				ex.printStackTrace();
				return null;
			}
			catch (final MalformedURLException ex)
			{
				throw new RuntimeException(ex);
			}
		return null;
	}
}
