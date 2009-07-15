package org.namesonnodes.domain;

import javax.persistence.Version;

public abstract class PersistentEntity implements Comparable<PersistentEntity>, Persistent
{
	private int version = 0;
	public int compareTo(final PersistentEntity o)
	{
		return getId() - o.getId();
	}
	public abstract int getId();
	@Version
	public int getVersion()
	{
		return version;
	}
	public abstract void setId(int id);
	public void setVersion(final int version)
	{
		this.version = version;
	}
}
