package org.namesonnodes.commands.specimens.test;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.namesonnodes.commands.specimens.CreateCatalogue;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.persist.HibernateBundle;

public class CreateCatalogueTest
{
	@Test
	public void testExecute() throws Exception
	{
		final CreateCatalogue createCatalogue = new CreateCatalogue();
		createCatalogue.setAbbr("YPM-VP");
		createCatalogue.setName("Yale Peabody Museum: Vertebrate Paleontology");
		createCatalogue.setUri("http://www.peabody.yale.edu/collections/vp");
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			final AuthorityIdentifier catalogue = createCatalogue.execute(hb.getSession());
			assertEquals("YPM-VP", catalogue.getEntity().getLabel().getAbbr());
			assertEquals("Yale Peabody Museum: Vertebrate Paleontology", catalogue.getEntity().getLabel().getName());
			assertEquals("http://www.peabody.yale.edu/collections/vp", catalogue.getUri());
		}
		catch (final Exception ex)
		{
			throw ex;
		}
		finally
		{
			hb.cancel();
		}
	}
}
