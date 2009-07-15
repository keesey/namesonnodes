package org.namesonnodes.commands;

import java.io.Serializable;
import org.hibernate.Session;

public interface Command<R> extends Serializable
{
	public void clearResult();
	public R execute(Session session) throws CommandException;
	public boolean readOnly();
	public boolean requiresCommit();
	public String toCommandString();
}
