package org.namesonnodes.commands.nomenclature;

import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.CommandUtil;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class ExtractTypes implements Command<Set<TaxonIdentifier>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -8868458279759876813L;
	private Command<RankDefinition> definitionCommand;
	public ExtractTypes()
	{
		super();
	}
	public ExtractTypes(final Command<RankDefinition> definitionCommand)
	{
		super();
		this.definitionCommand = definitionCommand;
	}
	public void clearResult()
	{
		definitionCommand.clearResult();
	}
	public Set<TaxonIdentifier> execute(final Session session) throws CommandException
	{
		try
		{
			return definitionCommand.execute(session).getTypes();
		}
		catch (final NullPointerException ex)
		{
			if (definitionCommand == null)
				throw new CommandException("No definition provided.");
			else
				throw ex;
		}
	}
	public Command<RankDefinition> getDefinitionCommand()
	{
		return definitionCommand;
	}
	public boolean readOnly()
	{
		return definitionCommand.readOnly();
	}
	public boolean requiresCommit()
	{
		return definitionCommand.requiresCommit();
	}
	public void setDefinitionCommand(final Command<RankDefinition> definitionCommand)
	{
		this.definitionCommand = definitionCommand;
	}
	public String toCommandString()
	{
		final String[] attrNames = { "definition" };
		final Object[] values = { definitionCommand };
		return CommandUtil.write("ExtractTypes", attrNames, values);
	}
}
