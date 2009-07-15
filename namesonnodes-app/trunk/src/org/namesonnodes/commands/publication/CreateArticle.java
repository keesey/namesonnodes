package org.namesonnodes.commands.publication;

import static org.namesonnodes.niso.sici.CodeStructureIdentifier.CSI2;
import static org.namesonnodes.utils.CollectionUtil.createStringList;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.niso.NISOException;
import org.namesonnodes.niso.sici.BICISchema;
import org.namesonnodes.niso.sici.ChronologyDate;
import org.namesonnodes.niso.sici.DerivativePartIdentifier;
import org.namesonnodes.niso.sici.SICI;
import org.namesonnodes.niso.sici.SICISchema;

public class CreateArticle extends AbstractCommand<AuthorityIdentifier>
{
	private static final long serialVersionUID = -8297443993541838452L;
	private final CreatePublication createPublication = new CreatePublication();
	protected final SICI sici = new SICI();
	private String title = "";
	public CreateArticle()
	{
		super();
		sici.setCodeStructureIdentifier(CSI2);
		sici.setDerivativePartIdentifier(DerivativePartIdentifier.ITEM_OR_CONTRIBUTION);
		sici.setMediumFormatIdentifier("TX");
		sici.setStandardVersionNumber(2);
	}
	public CreateArticle(final Object[] authorFamilyNames, final Object[] authorFullNames, final ChronologyDate date,
	        final String title, final String standardNumber, final String location)
	{
		this();
		setAuthorFamilyNames(createStringList(authorFamilyNames));
		setAuthorFullNames(createStringList(authorFullNames));
		setDate(date);
		setTitle(title);
		setStandardNumber(standardNumber);
		setLocation(location);
	}
	public CreateArticle(final String authorFamilyNames, final String authorFullNames, final ChronologyDate date,
	        final String title, final String standardNumber, final String location)
	{
		this();
		setAuthorFamilyNames(createStringList(authorFamilyNames.split("\\s*[,;]\\s*")));
		setAuthorFullNames(createStringList(authorFullNames.split("\\s*[,;]\\s*")));
		setDate(date);
		setTitle(title);
		setStandardNumber(standardNumber);
		setLocation(location);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] n = { "authorFamilyNames", "authorFullNames", "date", "title", "inSerial", "standardNumber",
		        "mediumFormatIdentifier", "location" };
		return n;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { getAuthorFamilyNames(), getAuthorFullNames(), getDate(), getTitle(), getInSerial(),
		        getStandardNumber(), getMediumFormatIdentifier(), getLocation() };
		return v;
	}
	@Override
	protected AuthorityIdentifier doExecute(final Session session) throws CommandException
	{
		updateChronology();
		try
		{
			createPublication.setUri(sici.toURI());
		}
		catch (final UnsupportedEncodingException ex)
		{
			throw new CommandException(ex);
		}
		catch (final NISOException ex)
		{
			throw new CommandException(ex);
		}
		return createPublication.execute(session);
	}
	public final List<String> getAuthorFamilyNames()
	{
		return createPublication.getAuthorFamilyNames();
	}
	public final List<String> getAuthorFullNames()
	{
		return createPublication.getAuthorFullNames();
	}
	public final ChronologyDate getDate()
	{
		return createPublication.getDate();
	}
	public final List<List<String>> getEnumerationValues()
	{
		return sici.getEnumerationValues();
	}
	public final boolean getInSerial()
	{
		return sici.getSchema() == SICISchema.INSTANCE;
	}
	public final String getLocation()
	{
		return sici.getLocation();
	}
	public final String getMediumFormatIdentifier()
	{
		return sici.getMediumFormatIdentifier();
	}
	public final String getStandardNumber()
	{
		return sici.getStandardNumber();
	}
	public final String getTitle()
	{
		return title;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return createPublication.requiresCommit();
	}
	public final void setAuthorFamilyNames(final List<String> authorFamilyNames)
	{
		createPublication.setAuthorFamilyNames(authorFamilyNames);
	}
	public final void setAuthorFullNames(final List<String> authorFullNames)
	{
		createPublication.setAuthorFullNames(authorFullNames);
	}
	public final void setDate(final ChronologyDate date)
	{
		createPublication.setDate(date);
	}
	public final void setEnumerationValues(final List<List<String>> enumeration)
	{
		sici.setEnumerationValues(enumeration);
	}
	public final void setInSerial(final boolean inSerial)
	{
		sici.setSchema(inSerial ? SICISchema.INSTANCE : BICISchema.INSTANCE);
	}
	public final void setLocation(final String location)
	{
		sici.setLocation(location);
	}
	public final void setMediumFormatIdentifier(final String mediumFormatIdentifier)
	{
		sici.setMediumFormatIdentifier(mediumFormatIdentifier);
	}
	public final void setStandardNumber(final String number)
	{
		sici.setStandardNumber(number);
	}
	public final void setTitle(final String title)
	{
		this.title = title;
		sici.setTitle(title);
	}
	public final String toURI() throws NISOException, UnsupportedEncodingException
	{
		updateChronology();
		return sici.toURI();
	}
	private void updateChronology()
	{
		if (sici.getChronology().isEmpty())
		{
			final List<ChronologyDate> chronology = new ArrayList<ChronologyDate>();
			chronology.add(getDate());
			sici.setChronology(chronology);
		}
	}
}
