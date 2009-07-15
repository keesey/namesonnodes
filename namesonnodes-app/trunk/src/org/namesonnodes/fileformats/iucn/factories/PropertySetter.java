package org.namesonnodes.fileformats.iucn.factories;

public interface PropertySetter<E, P>
{
	public void setProperty(final E element, final P propertyValue);
}
