package org.namesonnodes.persist;

import java.util.Collection;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.cfg.Configuration;
import org.hibernate.tool.hbm2ddl.SchemaExport;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.PersistentEntity;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Definition;
import org.namesonnodes.domain.entities.Heredity;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.PhyloDefinition;
import org.namesonnodes.domain.entities.Qualified;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.SpecimenDefinition;
import org.namesonnodes.domain.entities.StateDefinition;
import org.namesonnodes.domain.entities.Synonymy;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.domain.users.UserAccount;

public final class HibernateUtil
{
	private static Configuration configuration = null;
	@SuppressWarnings("unchecked")
	private static final Class[] PERSISTENT_CLASSES = { Authority.class, AuthorityIdentifier.class, BioFile.class,
	        Dataset.class, Definition.class, Heredity.class, Inclusion.class, PersistentEntity.class,
	        PhyloDefinition.class, Qualified.class, RankDefinition.class, SpecimenDefinition.class,
	        StateDefinition.class, Synonymy.class, TaxonIdentifier.class, Taxon.class, UserAccount.class };
	private static SessionFactory sessionFactory = null;
	public static void cancelSession(final Session session)
	{
		if (session != null)
			try
			{
				session.close();
			}
			catch (final HibernateException ex)
			{
				// Ignore.
			}
	}
	public static void cancelTransaction(final Transaction txn)
	{
		if (txn != null)
			try
			{
				txn.rollback();
			}
			catch (final HibernateException ex)
			{
				// Ignore.
			}
	}
	public static void commitSession(final Session session) throws NullPointerException
	{
		if (session == null)
			throw new NullPointerException("Null session.");
		else
			session.close();
	}
	public static void commitTransaction(final Transaction txn) throws HibernateException
	{
		if (txn == null)
			throw new NullPointerException("Null transaction.");
		else
			txn.commit();
	}
	public static void exportSchema() throws HibernateException
	{
		final SchemaExport export = new SchemaExport(getConfiguration());
		export.drop(true, true);
		export.create(true, true);
	}
	private static Configuration getConfiguration() throws MappingException
	{
		if (configuration == null)
		{
			configuration = new AnnotationConfiguration();
			for (final Class<? extends Object> persistentClass : PERSISTENT_CLASSES)
				((AnnotationConfiguration) configuration).addAnnotatedClass(persistentClass);
		}
		return configuration;
	}
	public static Session getSession() throws HibernateException
	{
		return getSessionFactory().openSession();
	}
	private static SessionFactory getSessionFactory() throws HibernateException
	{
		if (sessionFactory == null)
			sessionFactory = getConfiguration().buildSessionFactory();
		return sessionFactory;
	}
	public static Transaction getTransaction(final Session session) throws HibernateException
	{
		try
		{
			return session.beginTransaction();
		}
		catch (final HibernateException ex)
		{
			cancelSession(session);
			throw ex;
		}
	}
	public static void saveEntities(final Collection<? extends Persistent> entities) throws HibernateException
	{
		final HibernateBundle hb = new HibernateBundle();
		try
		{
			for (final Persistent entity : entities)
				hb.getSession().persist(entity);
			hb.commit();
		}
		catch (final RuntimeException ex)
		{
			hb.cancel();
			throw ex;
		}
	}
}
