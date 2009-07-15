package org.namesonnodes.domain.entities;

public final class SpecimenDefinition extends Definition
{
	@Override
	protected String toFormulaString()
	{
		return "{x : x is represented by a catalogued specimen #" + getId() + "}";
	}
}
