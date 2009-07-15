package org.namesonnodes.fileformats.iucn.model;

public final class CommonName
{
	public String lang;
	public String name;
	@Override
	public boolean equals(final Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final CommonName other = (CommonName) obj;
		if (lang == null)
		{
			if (other.lang != null)
				return false;
		}
		else if (!lang.equals(other.lang))
			return false;
		if (name == null)
		{
			if (other.name != null)
				return false;
		}
		else if (!name.equals(other.name))
			return false;
		return true;
	}
	@Override
	public int hashCode()
	{
		final int PRIME = 31;
		int result = 1;
		result = PRIME * result + (lang == null ? 0 : lang.hashCode());
		result = PRIME * result + (name == null ? 0 : name.hashCode());
		return result;
	}
}
