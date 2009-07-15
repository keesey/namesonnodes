package org.namesonnodes.servlets;

import static org.namesonnodes.servlets.ServletUtil.writeExceptionResponse;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.namesonnodes.domain.DuplicateException;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.fileformats.nexus.NexusFetcher;
import org.namesonnodes.fileformats.nexus.NexusSaver;
import org.namesonnodes.persist.HibernateBundle;
import com.oreilly.servlet.multipart.FilePart;
import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.Part;

/**
 * Servlet that handles the uploading and downloading of bioinformatics files
 * (currently just NEXUS).
 * 
 * @author T. Michael Keesey
 * @see http://www.ncbi.nlm.nih.gov/pubmed/11975335
 */
public final class BioFileServlet extends HttpServlet
{
	public static final int MAX_SIZE = 512 * 1024;
	private static final long serialVersionUID = 3973274197541838339L;
	/**
	 * Writes the response for when the NEXUS file has already been saved to the
	 * database.
	 * <p>
	 * The response consists of XML in the following format:
	 * <code>&lt;response&gt;&lt;duplicate id=&quot;<i>dupeID</i>&quot;/&gt;&lt;/response&gt;</code>
	 * </p>
	 * 
	 * @param response
	 *            Servlet response to write to.
	 * @param dupeID
	 *            Primary key of the NEXUS file which was already uploaded.
	 * @throws IOException
	 *             If an I/O error occurs.
	 */
	private static void writeDuplicateResponse(final HttpServletResponse response, final Integer dupeID)
	        throws IOException
	{
		response.getOutputStream().print("<response><duplicate id=\"" + dupeID + "\"/></response>");
		response.getOutputStream().flush();
	}
	/**
	 * Writes the response for when a new NEXUS file is added to the database.
	 * <p>
	 * The response consists of XML in the following format:
	 * <code>&lt;response&gt;&lt;new id=&quot;<i>newID</i>&quot;/&gt;&lt;/response&gt;</code>
	 * </p>
	 * 
	 * @param response
	 *            Servlet response to write to.
	 * @param newID
	 *            Primary key of the NEXUS file object which has been saved to
	 *            the database.
	 * @throws IOException
	 *             If an I/O error occurs.
	 */
	private static void writeSaveResponse(final HttpServletResponse response, final Integer newID) throws IOException
	{
		response.getOutputStream().print("<response><new id=\"" + newID + "\"/></response>");
		response.getOutputStream().flush();
	}
	/**
	 * Retrieves a NEXUS file's source from the database and outputs it for
	 * download.
	 * <p>
	 * A valid request must include a parameter named <code>id</code> which
	 * indicates the primary key of a NEXUS file in the database.
	 * </p>
	 * 
	 * @param request
	 *            Incoming servlet request.
	 * @param reponse
	 *            Outgoing servlet response.
	 * @throws IOException
	 *             If an I/O error occurs.
	 * @throws ServletException
	 *             If any other error occurs.
	 */
	@Override
	protected final void doGet(final HttpServletRequest request, final HttpServletResponse response)
	        throws ServletException, IOException
	{
		NexusFetcher.fetch(request, response);
	}
	/**
	 * Writes an uploaded NEXUS file to the database. Outputs an XML message
	 * indicating the status after the call.
	 * <p>
	 * A valid request must be multipart and include a one file, a
	 * validly-formatted NEXUS file.
	 * </p>
	 * <p>
	 * If the file has already been uploaded, the response will look like this:
	 * 
	 * <code>&lt;response&gt;&lt;duplicate id=&quot;<i>dupeID</i>&quot;/&gt;&lt;/response&gt;</code>
	 * (where <i><code>dupeID</code></i> is the primary key, an integer, of the
	 * NEXUS file object that was already created in the database).
	 * </p>
	 * <p>
	 * If the file has not already been uploaded, the response will look like
	 * this:
	 * <code>&lt;response&gt;&lt;new id=&quot;<i>newID</i>&quot;/&gt;&lt;/response&gt;</code>
	 * (where <i><code>newID</code></i> is the primary key, an integer, of the
	 * newly-created NEXUS file object in the database).
	 * </p>
	 * <p>
	 * If an error occurs, the response will look like this:
	 * 
	 * <code>&lt;response&gt;&lt;exception message=&quot;<i>error message</i>&quot;/&gt;&lt;/response&gt;</code>
	 * (where <i><code>error message</code></i> is text indicating th enature of
	 * the error). Errors may also be logged (they are written to the standard
	 * output).
	 * </p>
	 * 
	 * @param request
	 *            Incoming servlet request.
	 * @param reponse
	 *            Outgoing servlet response.
	 * @throws IOException
	 *             If an I/O error occurs. (This should never happen.)
	 * @throws ServletException
	 *             If any other error occurs. (This should never happen.)
	 */
	@Override
	protected void doPost(final HttpServletRequest request, final HttpServletResponse response)
	        throws ServletException, IOException
	{
		HibernateBundle hb = null;
		try
		{
			int newID = 0;
			hb = new HibernateBundle();
			final MultipartParser parser = new MultipartParser(request, MAX_SIZE);
			Part part;
			while ((part = parser.readNextPart()) != null)
				if (part.isFile())
				{
					final FilePart filePart = (FilePart) part;
					// :TODO: Select saver based on content type, or possibly
					// some other criterion
					final BioFile file = new NexusSaver().save(hb.getSession(), filePart.getInputStream(), request
					        .getRemoteAddr());
					newID = file.getId();
					break;
				}
			if (newID == 0)
				throw new ServletException("No file was uploaded.");
			hb.commit();
			writeSaveResponse(response, newID);
		}
		catch (final DuplicateException ex)
		{
			if (hb != null)
				hb.cancel();
			writeDuplicateResponse(response, ex.getDuplicateID());
		}
		catch (final Exception ex)
		{
			if (hb != null)
				hb.cancel();
			writeExceptionResponse(response, ex);
		}
	}
}
