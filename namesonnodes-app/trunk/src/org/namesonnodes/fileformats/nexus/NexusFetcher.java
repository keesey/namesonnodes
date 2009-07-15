package org.namesonnodes.fileformats.nexus;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.criterion.Restrictions;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.persist.HibernateBundle;
import org.namesonnodes.utils.ArrayUtil;

public final class NexusFetcher
{
	/**
	 * Retrieves a NEXUS file's source and writes it in the servlet's response.
	 * <p>
	 * A valid request must include a parameter named <code>id</code> which
	 * indicates the primary key of a NEXUS file in the database.
	 * </p>
	 * 
	 * @param request
	 *            The servlet request containing the ID of the desired NEXUS
	 *            file.
	 * @param response
	 *            The response to write the NEXUS file's source to.
	 * @throws IOException
	 *             If an I/O error occurs.
	 * @throws ServletException
	 *             If any other error occurs.
	 * @see org.namesonnnexus.domain.nexus.BioFileSource#getId()
	 */
	@SuppressWarnings("unchecked")
	public static void fetch(final HttpServletRequest request, final HttpServletResponse response) throws IOException,
	        ServletException
	{
		final HibernateBundle hb = new HibernateBundle();
		BioFile bioFile = null;
		try
		{
			final Map map = request.getParameterMap();
			if (map.containsKey("id"))
			{
				final Integer id = readID(request);
				bioFile = (BioFile) hb.getSession().get(BioFile.class, id);
			}
			else if (map.containsKey("sourceHash"))
				bioFile = (BioFile) hb.getSession().createCriteria(BioFile.class).add(
				        Restrictions.eq("sourceHash", request.getParameter("sourceHash"))).uniqueResult();
			else
				throw new ServletException("No bioinformatics file specified.");
		}
		catch (final ServletException ex)
		{
			throw ex;
		}
		catch (final Exception ex)
		{
			throw new ServletException(ex);
		}
		finally
		{
			hb.cancel();
		}
		if (bioFile == null)
			throw new ServletException("Cannot find the specified file.");
		writeSource(bioFile, response);
	}
	/**
	 * Reads a NEXUS file's primary key from a servlet request.
	 * <p>
	 * A valid request must include a parameter named <code>id</code> which
	 * indicates the primary key of a NEXUS file in the database.
	 * </p>
	 * 
	 * @param request
	 *            Servlet request to read the ID from.
	 * @return Integer (primary key of a NEXUS file in the database).
	 * @throws ServletException
	 *             If any error occurs.
	 */
	private static Integer readID(final HttpServletRequest request) throws ServletException
	{
		try
		{
			return Integer.valueOf(request.getParameter("id"));
		}
		catch (final NumberFormatException ex)
		{
			throw new ServletException("Invalid ID in request.", ex);
		}
	}
	/**
	 * Write the NEXUS file that was read by
	 * {@link #fetch(HttpServletRequest, HttpServletResponse)} to a servlet's
	 * response.
	 * 
	 * @param response
	 *            Servlet response.
	 * @throws IOException
	 *             If an I/O error occurs.
	 */
	private static void writeSource(final BioFile bioFile, final HttpServletResponse response) throws IOException
	{
		final byte[] output = ArrayUtil.charsToBytes(bioFile.getSource());
		response.addHeader("Content-Type", "text/plain");
		response.addHeader("Content-Disposition", "attachment; filename=NON_"
		        + Integer.toHexString(bioFile.getAuthority().getId()) + ".nex");
		response.addIntHeader("Content-Length", output.length);
		response.getOutputStream().write(output);
		response.getOutputStream().flush();
	}
}
