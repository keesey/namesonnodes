package org.namesonnodes.commands.publication;

import org.namesonnodes.niso.sici.BICISchema;
import org.namesonnodes.niso.sici.ChronologyDate;

public final class CreateChapter extends CreateArticle
{
	private static final long serialVersionUID = -3457451627239659691L;
	public CreateChapter()
	{
		super();
		sici.setSchema(BICISchema.INSTANCE);
	}
	public CreateChapter(final Object[] authorFamilyNames, final Object[] authorFullNames, final ChronologyDate date,
	        final String title, final String standardNumber, final String location)
	{
		super(authorFamilyNames, authorFullNames, date, title, standardNumber, location);
		sici.setSchema(BICISchema.INSTANCE);
	}
	public CreateChapter(final String authorFamilyNames, final String authorFullNames, final ChronologyDate date,
	        final String title, final String standardNumber, final String location)
	{
		super(authorFamilyNames, authorFullNames, date, title, standardNumber, location);
		sici.setSchema(BICISchema.INSTANCE);
	}
}
