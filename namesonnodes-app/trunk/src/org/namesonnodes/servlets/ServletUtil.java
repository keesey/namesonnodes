package org.namesonnodes.servlets;

import static org.namesonnodes.utils.DocumentUtil.encode;
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

public final class ServletUtil
{
	/**
	 * Writes an exception to the servlet response.
	 * <p>
	 * The response consists of XML in the following format:
	 * 
	 * <code>&lt;response&gt;&lt;exception message=&quot;<i>ex.getMessage()</i>&quot;/&gt;&lt;/response&gt;</code>
	 * </p>
	 * <p>
	 * Also sends the exception's stack to standard output.
	 * </p>
	 * 
	 * @param response
	 *            Servlet response to write the exception to.
	 * @param ex
	 *            The exception to report.
	 * @throws IOException
	 *             If an I/O error occurs.
	 */
	public static void writeExceptionResponse(final HttpServletResponse response, final Exception ex)
	        throws IOException
	{
		response.getOutputStream().print(
		        "<response><exception><message>" + encode(ex.getMessage()) + "</message><stack>");
		for (final StackTraceElement element : ex.getStackTrace())
			response.getOutputStream().print(
			        "<element line=\"" + element.getLineNumber() + "\" class=\"" + encode(element.getClassName())
			                + "\" method=\"" + encode(element.getMethodName()) + "/>");
		response.getOutputStream().print("</stack></exception></response>");
		response.getOutputStream().flush();
		ex.printStackTrace();
	}
	private ServletUtil()
	{
		super();
	}
}
