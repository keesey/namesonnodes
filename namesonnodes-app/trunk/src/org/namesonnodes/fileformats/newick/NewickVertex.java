package org.namesonnodes.fileformats.newick;

public final class NewickVertex
{
	public int index;
	public String label;
	@Override
	public boolean equals(final Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final NewickVertex other = (NewickVertex) obj;
		if (index != other.index)
			return false;
		if (label == null)
		{
			if (other.label != null)
				return false;
		}
		else if (!label.equals(other.label))
			return false;
		return true;
	}
	@Override
	public int hashCode()
	{
		final int PRIME = 31;
		int result = 1;
		result = PRIME * result + index;
		result = PRIME * result + (label == null ? 0 : label.hashCode());
		return result;
	}
}
