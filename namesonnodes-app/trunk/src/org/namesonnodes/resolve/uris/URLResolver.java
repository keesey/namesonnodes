package org.namesonnodes.resolve.uris;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.util.HashSet;
import java.util.Set;

public final class URLResolver implements URIResolver
{
	private static final Set<String> SCHEMES = new HashSet<String>();
	static
	{
		SCHEMES.add("about");
		SCHEMES.add("feed");
		SCHEMES.add("ftp");
		SCHEMES.add("ftps");
		SCHEMES.add("gopher");
		SCHEMES.add("http");
		SCHEMES.add("https");
		SCHEMES.add("im");
		SCHEMES.add("mailto");
		SCHEMES.add("news");
		SCHEMES.add("rtsp");
		SCHEMES.add("sftp");
		SCHEMES.add("shttp");
		SCHEMES.add("telnet");
	}
	public URL resolve(final URI uri)
	{
		if (uri.getScheme() == null)
			return null;
		try
		{
			return SCHEMES.contains(uri.getScheme()) ? uri.toURL() : null;
		}
		catch (final MalformedURLException ex)
		{
			ex.printStackTrace();
			return null;
		}
	}
}
