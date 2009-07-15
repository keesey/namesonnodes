package org.namesonnodes.domain.entities;

import org.namesonnodes.domain.Persistent;

public interface Labelled extends Persistent
{
	public Label getLabel();
	public void setLabel(Label label);
}
