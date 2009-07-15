package org.namesonnodes.commands.nomenclature.phylo;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.nomenclature.CreateUndefinedName;
import org.namesonnodes.commands.nomenclature.PhyloDefine;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.w3c.dom.Document;

public final class CreatePhyloCladeName extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = -8974714086364217334L;
	private final PhyloCode authority = new PhyloCode();
	private final CreateUndefinedName createName = new CreateUndefinedName();
	private final PhyloDefine define = new PhyloDefine();
	public CreatePhyloCladeName()
	{
		super();
		createName.setAllowExisting(true);
		createName.setAuthorityCommand(authority);
		createName.setItalics(true);
		define.setAuthorityCommand(authority);
		define.setIdentifierCommand(createName);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "name", "prose", "formula" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getName(), getProse(), getFormula() };
		return v;
	}
	@Override
	public void clearResult()
	{
		createName.clearResult();
		authority.clearResult();
		define.clearResult();
		super.clearResult();
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (getName() != null && !getName().matches("^([A-Z][a-z]+-)?[A-Z][a-z]+$"))
			throw new CommandException("Invalid PhyloCode clade name.");
		return createName.execute(session);
	}
	public final Document getFormula()
	{
		return define.getFormula();
	}
	public final String getName()
	{
		return createName.getName();
	}
	public final String getProse()
	{
		return define.getProse();
	}
	public boolean readOnly()
	{
		return createName.readOnly() && define.readOnly();
	}
	public boolean requiresCommit()
	{
		return createName.requiresCommit() || define.requiresCommit();
	}
	public final void setFormula(final Document formula)
	{
		define.setFormula(formula);
	}
	public final void setName(final String name)
	{
		createName.setName(name);
	}
	public final void setProse(final String prose)
	{
		define.setProse(prose);
	}
}
