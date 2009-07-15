package org.namesonnodes.fileformats.newick;

public final class NewickArc
{
	public NewickVertex head;
	public NewickVertex tail;
	public double weight;
	public NewickArc(final NewickVertex head, final NewickVertex tail)
	{
		super();
		this.head = head;
		this.tail = tail;
		weight = 0d;
	}
	public NewickArc(final NewickVertex head, final NewickVertex tail, final double weight)
	{
		super();
		this.head = head;
		this.tail = tail;
		this.weight = weight;
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
		final NewickArc other = (NewickArc) obj;
		if (head == null)
		{
			if (other.head != null)
				return false;
		}
		else if (!head.equals(other.head))
			return false;
		if (tail == null)
		{
			if (other.tail != null)
				return false;
		}
		else if (!tail.equals(other.tail))
			return false;
		if (Double.doubleToLongBits(weight) != Double.doubleToLongBits(other.weight))
			return false;
		return true;
	}
	@Override
	public int hashCode()
	{
		final int PRIME = 31;
		int result = 1;
		result = PRIME * result + (head == null ? 0 : head.hashCode());
		result = PRIME * result + (tail == null ? 0 : tail.hashCode());
		long temp;
		temp = Double.doubleToLongBits(weight);
		result = PRIME * result + (int) (temp ^ temp >>> 32);
		return result;
	}
}
