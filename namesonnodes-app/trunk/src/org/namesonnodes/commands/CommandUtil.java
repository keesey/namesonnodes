package org.namesonnodes.commands;

import java.util.Collection;
import java.util.Set;
import javax.xml.transform.TransformerException;
import org.namesonnodes.utils.CollectionUtil;
import org.namesonnodes.utils.DocumentUtil;
import org.w3c.dom.Document;

public final class CommandUtil
{
	public static String indent = "";
	public static String write(final String commandName, final String[] attrNames, final Object[] values)
	{
		return commandName + " : {" + writeAttributes(attrNames, values) + "}";
	}
	@SuppressWarnings("unchecked")
	public static String writeAttributes(final String[] names, final Object[] values)
	{
		final int n = names.length < values.length ? names.length : values.length;
		String s = "";
		for (int i = 0; i < n; ++i)
		{
			if (i != 0)
				s += ", ";
			s += names[i] + "=";
			final Object value = values[i];
			if (value == null)
				s += "<null>";
			else if (value instanceof String)
				s += "'" + value.toString().replaceAll("'", "\\'") + "'";
			else if (value instanceof Command)
				s += "(" + ((Command) value).toCommandString() + ")";
			else if (value instanceof Set)
				s += "{" + CollectionUtil.join((Set) value, ", ") + "}";
			else if (value instanceof Collection)
				s += "(" + CollectionUtil.join((Collection) value, ", ") + ")";
			else if (value instanceof Document)
				try
				{
					s += DocumentUtil.write((Document) value);
				}
				catch (final TransformerException ex)
				{
					s += "<exception: " + ex.getMessage() + ">";
				}
			else
				s += "[" + value.toString() + "]";
		}
		return s;
	}
	private CommandUtil()
	{
		super();
	}
}
