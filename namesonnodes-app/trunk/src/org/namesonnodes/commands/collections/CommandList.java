package org.namesonnodes.commands.collections;

import static org.namesonnodes.commands.CommandUtil.indent;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;

public final class CommandList<T> implements Command<List<T>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3124138968526413972L;
	private final List<Command<? extends T>> commands = new ArrayList<Command<? extends T>>();
	private boolean executed = false;
	private final List<T> results = new ArrayList<T>();
	public CommandList()
	{
		super();
	}
	public boolean add(final Command<? extends T> o)
	{
		clearResult();
		return commands.add(o);
	}
	public boolean addAll(final Collection<? extends Command<? extends T>> c)
	{
		clearResult();
		return commands.addAll(c);
	}
	public void clearResult()
	{
		executed = false;
		results.clear();
		for (final Command<? extends Object> command : commands)
			command.clearResult();
	}
	public List<T> execute(final Session session) throws CommandException
	{
		if (!executed)
		{
			results.clear();
			for (final Command<? extends T> command : commands)
				results.add(command.execute(session));
			executed = true;
		}
		return results;
	}
	public List<Command<? extends T>> getCommands()
	{
		return commands;
	}
	public boolean readOnly()
	{
		for (final Command<? extends Object> command : commands)
			if (!command.readOnly())
				return false;
		return true;
	}
	public boolean requiresCommit()
	{
		for (final Command<? extends Object> command : commands)
			if (command.requiresCommit())
				return true;
		return false;
	}
	public void setCommands(final List<Command<? extends T>> commands)
	{
		this.commands.clear();
		if (commands != null)
			this.commands.addAll(commands);
	}
	public String toCommandString()
	{
		String s = "CommandList:\n" + indent + "(\n";
		indent += "\t";
		final int n = commands.size();
		for (int i = 0; i < n; ++i)
		{
			final Command<? extends Object> command = commands.get(i);
			s += indent + command.toCommandString() + (i < n - 1 ? "," : "") + "\n";
		}
		indent = indent.substring(0, indent.length() - 1);
		s += indent + ")";
		return s;
	}
}
