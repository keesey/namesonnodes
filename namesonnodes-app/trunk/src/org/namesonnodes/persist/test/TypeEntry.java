package org.namesonnodes.persist.test;

final class TypeEntry implements Createable, Droppable
{
	public String body;
	public String name;
	public TypeEntry(final String name, final String body)
	{
		super();
		this.name = name;
		this.body = body;
	}
	public String createSQL()
	{
		return "CREATE TYPE " + name + " AS\n" + body + ";\nALTER TYPE " + name + " OWNER TO pgsql";
	}
	public String dropSQL()
	{
		return "DROP TYPE IF EXISTS " + name + " CASCADE";
	}
}
