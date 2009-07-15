package org.namesonnodes.servlets;

import static org.namesonnodes.servlets.ServletUtil.writeExceptionResponse;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.namesonnodes.fileformats.iucn.IUCNSaver;
import org.namesonnodes.persist.HibernateBundle;
import com.oreilly.servlet.multipart.FilePart;
import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.Part;

public final class IUCNFileServlet extends HttpServlet
{
	public static final int MAX_SIZE = 512 * 1024;
	private static final long serialVersionUID = -5909513968874317553L;
	@Override
	protected void doPost(final HttpServletRequest request, final HttpServletResponse response)
	        throws ServletException, IOException
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			final MultipartParser parser = new MultipartParser(request, MAX_SIZE);
			Part part;
			boolean saved = false;
			while ((part = parser.readNextPart()) != null)
				if (part.isFile())
				{
					final FilePart filePart = (FilePart) part;
					new IUCNSaver().save(filePart.getInputStream(), hb.getSession());
					saved = true;
					break;
				}
			if (!saved)
				throw new ServletException("No file was uploaded.");
			hb.commit();
		}
		catch (final Exception ex)
		{
			writeExceptionResponse(response, ex);
			hb.cancel();
			return;
		}
		response.getOutputStream().print("<response><status>1</status></response>");
		response.getOutputStream().flush();
	}
}
