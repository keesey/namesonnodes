package org.namesonnodes.persist.test;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.codec.EncoderException;
import org.hibernate.Session;
import org.junit.Test;
import org.namesonnodes.commands.nomenclature.bacterial.BacteriologicalCode;
import org.namesonnodes.commands.nomenclature.botanic.BotanicalCode;
import org.namesonnodes.commands.nomenclature.phylo.PhyloCode;
import org.namesonnodes.commands.nomenclature.zoo.ZoologicalCode;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Label;
import org.namesonnodes.domain.entities.StateDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.persist.HibernateBundle;
import org.namesonnodes.persist.HibernateUtil;

public class HibernateTest
{
	private static final List<FunctionEntry> functions = createFunctionList();
	private static final List<TypeEntry> types = createTypeList();
	@SuppressWarnings("deprecation")
	private static void create(final List<? extends Createable> list, final Session session)
	{
		for (final Createable entry : list)
		{
			System.out.println("\t" + entry.toString());
			try
			{
				session.connection().createStatement().execute(entry.createSQL());
			}
			catch (final SQLException ex)
			{
				throw new RuntimeException(ex);
			}
		}
	}
	private static List<FunctionEntry> createFunctionList()
	{
		final List<FunctionEntry> entries = new ArrayList<FunctionEntry>();
		entries.add(new FunctionEntry("array_to_set(ints integer[])", "SETOF integer", "DECLARE\n" + "\t\ti integer;\n"
		        + "\t\tn integer;\n" + "\tBEGIN\n" + "\t\ti := array_lower(ints, 1);\n" + "\t\tIF i IS NULL THEN\n"
		        + "\t\t\tRETURN;\n" + "\t\tEND IF;\n" + "\t\tn := array_upper(ints, 1);\n" + "\t\tWHILE i <= n LOOP\n"
		        + "\t\t\tRETURN NEXT ints[i];\n" + "\t\t\ti := i + 1;\n" + "\t\tEND LOOP;\n" + "\t\tRETURN;\n"
		        + "\tEND", "plpgsql", FunctionEntry.IMMUTABLE));
		return entries;
	}
	private static void createFunctionsAndTypes()
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			create(types, hb.getSession());
			create(functions, hb.getSession());
		}
		catch (final RuntimeException ex)
		{
			hb.cancel();
			throw ex;
		}
		hb.commit();
	}
	private static List<TypeEntry> createTypeList()
	{
		final List<TypeEntry> entries = new ArrayList<TypeEntry>();
		return entries;
	}
	private static void drop(final List<? extends Droppable> list, final Session session)
	{
		for (final Droppable entry : list)
			session.createSQLQuery(entry.dropSQL()).executeUpdate();
	}
	private static void dropFunctionsAndTypes()
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			drop(functions, hb.getSession());
			drop(types, hb.getSession());
		}
		catch (final RuntimeException ex)
		{
			hb.cancel();
			throw ex;
		}
		hb.commit();
	}
	private static List<Persistent> necessaryEntities() throws EncoderException
	{
		final List<Persistent> itemsToSave = new ArrayList<Persistent>();
		final AuthorityIdentifier icbn = new AuthorityIdentifier(new Authority(new Label(
		        "International Code of Botanical Nomenclature (Vienna Code)", "ICBN Vienna", true)), BotanicalCode.URI);
		itemsToSave.add(icbn);
		final AuthorityIdentifier icbn2 = new AuthorityIdentifier(icbn.getEntity(), "http://ibot.sav.sk/icbn/main.htm");
		itemsToSave.add(icbn2);
		final AuthorityIdentifier iczn = new AuthorityIdentifier(new Authority(new Label(
		        "International Code of Zoological Nomenclature, Fourth Edition", "ICZN 4", true)), ZoologicalCode.URI);
		itemsToSave.add(iczn);
		final AuthorityIdentifier iczn2 = new AuthorityIdentifier(iczn.getEntity(), "http://www.iczn.org/iczn");
		itemsToSave.add(iczn2);
		final AuthorityIdentifier icnb = new AuthorityIdentifier(new Authority(new Label(
		        "International Code of Nomenclature of Bacteria, 1990 Revision", "ICNB 1990", true)),
		        BacteriologicalCode.URI);
		itemsToSave.add(icnb);
		final AuthorityIdentifier icpn = new AuthorityIdentifier(new Authority(new Label(
		        "International Code of Phylogenetic Nomenclature, Version 4b", "PhyloCode 0.4b", true)), PhyloCode.URI);
		itemsToSave.add(icpn);
		final Authority iucnCategoriesCriteriaEntity = new Authority(new Label(
		        "IUCN Red List Categories and Criteria: Version 3.1", "IUCN 2001 Feb 9", true));
		final AuthorityIdentifier iucnCategoriesCriteria = new AuthorityIdentifier(iucnCategoriesCriteriaEntity,
		        "urn:isbn:2831706335");
		itemsToSave.add(iucnCategoriesCriteria);
		itemsToSave.add(new AuthorityIdentifier(iucnCategoriesCriteriaEntity,
		        "http://www.iucnredlist.org/static/categories_criteria_3_1"));
		final AuthorityIdentifier iucnRedList = new AuthorityIdentifier(new Authority(new Label(
		        "International Union for Conservation of Nature: Red List", "IUCN Red List", true)),
		        "http://iucnredlist.org");
		itemsToSave.add(iucnRedList);
		final Dataset iucnRedListAssessments = new Dataset();
		iucnRedListAssessments.setAuthority(iucnRedList);
		iucnRedListAssessments.setLocalName("assessments");
		iucnRedListAssessments.getLabel().setName("Assessments");
		itemsToSave.add(iucnRedListAssessments);
		final Dataset iucnRedListTaxonomy = new Dataset();
		iucnRedListTaxonomy.setAuthority(iucnRedList);
		iucnRedListTaxonomy.setLocalName("taxonomy");
		iucnRedListTaxonomy.getLabel().setName("Taxonomy");
		itemsToSave.add(iucnRedListTaxonomy);
		final int[] iucnYears = { 2002, 2003, 2004, 2006, 2007, 2008 };
		final String[] iucnCategories = { "EX", "EW", "CR", "EN", "VU", "LC", "DD", "NE" };
		final String[] iucnCategoryNames = { "Extinct", "Extinct In The Wild", "Critically Endangered", "Endangered",
		        "Vulnerable", "Least Concern", "Data Deficient", "Not Evaluated" };
		for (final int year : iucnYears)
			for (int i = 0; i < iucnCategoryNames.length; ++i)
				itemsToSave.add(new TaxonIdentifier(new Taxon(new StateDefinition()), iucnCategoriesCriteria,
				        "categories:" + iucnCategories[i] + ":" + year, new Label(iucnCategoryNames[i] + " (" + year
				                + ")", iucnCategories[i] + " (" + year + ")")));
		/*
		 * final Authority keesey = new Authority(new AuthorityIdentity("Timothy
		 * Michael Keesey", "Keesey", AuthorityCategory.USER_CATEGORIES),
		 * "mailto:keesey@gmail.com"); itemsToSave.add(keesey); final
		 * UserAccount keeseyUser = new UserAccount(keesey);
		 * itemsToSave.add(keeseyUser);
		 */
		return itemsToSave;
	}
	@Test
	public void populate() throws Exception
	{
		System.out.println("DROP FUNCTIONS AND TYPES");
		dropFunctionsAndTypes();
		System.out.println("EXPORT SCHEMA");
		HibernateUtil.exportSchema();
		System.out.println("CREATE FUNCTIONS AND TYPES");
		createFunctionsAndTypes();
		System.out.println("SAVE ENTITIES");
		HibernateUtil.saveEntities(necessaryEntities());
	}
}
