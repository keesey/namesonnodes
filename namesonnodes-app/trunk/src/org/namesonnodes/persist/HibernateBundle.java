package org.namesonnodes.persist;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public final class HibernateBundle
{
	private Session session = null;
	private Transaction txn = null;
	public HibernateBundle() throws HibernateException
	{
		super();
		session = HibernateUtil.getSession();
		txn = HibernateUtil.getTransaction(session);
	}
	public void cancel()
	{
		HibernateUtil.cancelTransaction(txn);
		HibernateUtil.cancelSession(session);
		session = null;
		txn = null;
	}
	public void commit() throws HibernateException
	{
		try
		{
			HibernateUtil.commitTransaction(txn);
			HibernateUtil.commitSession(session);
		}
		catch (final HibernateException ex)
		{
			HibernateUtil.cancelTransaction(txn);
			HibernateUtil.cancelSession(session);
			throw ex;
		}
		finally
		{
			session = null;
			txn = null;
		}
	}
	public Session getSession()
	{
		return session;
	}
}
