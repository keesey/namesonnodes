package org.namesonnodes.commands.collections;

import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.CommandUtil;

public class ExtractElement<T> implements Command<T>
{
	private static final long serialVersionUID = 6411439859549507710L;
	private int index = 0;
	private Command<List<T>> listCommand;
	public ExtractElement()
	{
		super();
	}
	public ExtractElement(final Command<List<T>> listCommand)
	{
		super();
		this.listCommand = listCommand;
	}
	public ExtractElement(final Command<List<T>> listCommand, final int index)
	{
		super();
		this.listCommand = listCommand;
		this.index = index;
	}
	public final void clearResult()
	{
		if (listCommand != null)
			listCommand.clearResult();
	}
	public final T execute(final Session session) throws CommandException
	{
		if (index < 0)
			throw new CommandException("Index is less than zero: " + index);
		final List<? extends T> results = listCommand.execute(session);
		if (results == null)
			throw new CommandException("List could not be retrieved.");
		if (results.size() <= index)
			throw new CommandException("Index (" + index + ") is beyond range of retrieved list (" + results.size()
			        + " elements).");
		return results.get(index);
	}
	public final int getIndex()
	{
		return index;
	}
	public final Command<List<T>> getListCommand()
	{
		return listCommand;
	}
	public final boolean readOnly()
	{
		return listCommand == null || listCommand.readOnly();
	}
	public final boolean requiresCommit()
	{
		return listCommand != null && listCommand.requiresCommit();
	}
	public final void setIndex(final int index)
	{
		this.index = index;
	}
	public final void setListCommand(final Command<List<T>> listCommand)
	{
		this.listCommand = listCommand;
	}
	public final String toCommandString()
	{
		final String[] names = { "index", "list" };
		final Object[] values = { index, listCommand };
		return CommandUtil.write(getClass().getSimpleName(), names, values);
	}
	@Override
	public final String toString()
	{
		return toCommandString();
	}
}
