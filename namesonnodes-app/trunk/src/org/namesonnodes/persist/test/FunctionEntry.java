package org.namesonnodes.persist.test;

final class FunctionEntry implements Createable, Droppable
{
	public static final String IMMUTABLE = "IMMUTABLE";
	public static final String STABLE = "STABLE";
	public static final String VOLATILE = "VOLATILE";
	protected String body;
	protected String language;
	protected String returnType;
	protected String signature;
	protected String volatility = STABLE;
	public FunctionEntry(final String signature, final String returnType, final String body, final String language)
	{
		this(signature, returnType, body, language, STABLE);
	}
	public FunctionEntry(final String signature, final String returnType, final String body, final String language,
	        final String volatility)
	{
		super();
		this.language = language;
		this.signature = signature;
		this.returnType = returnType;
		this.body = body;
		this.volatility = volatility;
	}
	public String createSQL()
	{
		return "CREATE OR REPLACE FUNCTION " + signature + "\n" + "\tRETURNS " + returnType + " AS\n" + "$BODY$\n"
		        + body + "\n$BODY$\n" + "\tLANGUAGE '" + language + "' " + volatility + " STRICT;\n"
		        + "ALTER FUNCTION " + signature + " OWNER TO pgsql;";
	}
	public String dropSQL()
	{
		return "DROP FUNCTION IF EXISTS " + signature + " CASCADE;";
	}
	@Override
	public String toString()
	{
		return "FUNCTION " + signature + " RETURNS " + returnType;
	}
}
