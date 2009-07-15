package org.namesonnodes.domain.entities;

public final class StateDefinition extends Definition
{
	@Override
	protected String toFormulaString()
	{
		return "{x : x exhibits character state #" + getId() + "}";
	}
}
