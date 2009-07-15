package org.namesonnodes.domain.entities;

import org.namesonnodes.domain.Persistent;

public interface Identifier<E extends Identified> extends Persistent
{
	public E getEntity();
	public void setEntity(E entity);
}
