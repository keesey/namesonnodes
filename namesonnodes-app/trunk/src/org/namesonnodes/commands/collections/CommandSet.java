package org.namesonnodes.commands.collections;

import static org.namesonnodes.commands.CommandUtil.indent;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;

public final class CommandSet<T> implements Command<Set<T>>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -9139563349663347378L;
	private final Set<Command<? extends T>> commands = new HashSet<Command<? extends T>>();
	private boolean executed = false;
	private final Set<T> results = new HashSet<T>();
	public CommandSet()
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
	public Set<T> execute(final Session session) throws CommandException
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
	public Set<Command<? extends T>> getCommands()
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
	public void setCommands(final Set<Command<? extends T>> commands)
	{
		this.commands.clear();
		if (commands != null)
			this.commands.addAll(commands);
	}
	public String toCommandString()
	{
		String s = "CommandSet:\n" + indent + "{\n";
		indent += "\t";
		final int n = commands.size();
		int i = 0;
		for (final Command<? extends Object> command : commands)
		{
			s += indent + command.toCommandString() + (i < n - 1 ? "," : "") + "\n";
			++i;
		}
		indent = indent.substring(0, indent.length() - 1);
		s += indent + "}";
		return s;
	}
}
