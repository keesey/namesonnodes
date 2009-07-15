package org.namesonnodes.resolve.qnames;

import java.net.URI;
import java.net.URISyntaxException;

public final class QName implements Cloneable
{
	private final String localName;
	private final URI uri;
	public QName(final String qName) throws URISyntaxException, IllegalArgumentException
	{
		super();
		if (qName == null)
			throw new IllegalArgumentException("No qualified name.");
		final String[] parts = qName.split("::");
		if (parts.length != 2)
			throw new IllegalArgumentException("Invalid qualified name.");
		if (parts[0].length() == 0)
			throw new IllegalArgumentException("No URI.");
		if (parts[1].length() == 0)
			throw new IllegalArgumentException("No local name.");
		this.uri = new URI(parts[0]);
		this.localName = parts[1];
	}
	public QName(final URI uri, final String localName) throws IllegalArgumentException
	{
		super();
		if (uri == null)
			throw new IllegalArgumentException("No URI.");
		if (localName == null || localName.length() == 0)
			throw new IllegalArgumentException("No local name.");
		this.uri = uri;
		this.localName = localName;
	}
	@Override
	protected QName clone()
	{
		return new QName(uri, localName);
	}
	@Override
	public boolean equals(final Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final QName other = (QName) obj;
		if (localName == null)
		{
			if (other.localName != null)
				return false;
		}
		else if (!localName.equals(other.localName))
			return false;
		if (uri == null)
		{
			if (other.uri != null)
				return false;
		}
		else if (!uri.toString().equals(other.uri.toString()))
			return false;
		return true;
	}
	public final String getLocalName()
	{
		return localName;
	}
	public final URI getUri()
	{
		return uri;
	}
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + (localName == null ? 0 : localName.hashCode());
		result = prime * result + (uri == null ? 0 : uri.toString().hashCode());
		return result;
	}
	@Override
	public String toString()
	{
		return uri.toString() + "::" + localName;
	}
}
