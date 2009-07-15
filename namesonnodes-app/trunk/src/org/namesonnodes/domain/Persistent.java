package org.namesonnodes.domain;

import javax.persistence.Id;
import javax.persistence.Version;

public interface Persistent
{
	@Id
	public int getId();
	@Version
	public int getVersion();
	public void setId(final int id);
	public void setVersion(final int version);
}