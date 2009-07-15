package org.namesonnodes.session;

import javax.servlet.http.HttpSession;
import flex.messaging.FlexContext;

public final class UserSession
{
	private static final String ACCOUNT_ID_ATTR_NAME = "account_id";
	private static final String IS_ADMIN_ATTR_NAME = "is_admin";
	public static int getAccountID()
	{
		final Object id = getHttpSession().getAttribute(ACCOUNT_ID_ATTR_NAME);
		if (id instanceof Integer)
			return (Integer) id;
		return 0;
	}
	private static HttpSession getHttpSession()
	{
		return FlexContext.getHttpRequest().getSession();
	}
	public static void initiate(final Integer accountID, final Boolean isAdmin) throws IllegalArgumentException
	{
		if (accountID <= 0)
			throw new IllegalArgumentException();
		getHttpSession().setAttribute(ACCOUNT_ID_ATTR_NAME, accountID);
		getHttpSession().setAttribute(IS_ADMIN_ATTR_NAME, isAdmin);
	}
	public static boolean isActive()
	{
		return getAccountID() > 0;
	}
	public static boolean isAdmin()
	{
		final Object isAdmin = getHttpSession().getAttribute(IS_ADMIN_ATTR_NAME);
		if (isAdmin instanceof Boolean)
			return (Boolean) isAdmin;
		return false;
	}
	public static void terminate()
	{
		getHttpSession().removeAttribute(ACCOUNT_ID_ATTR_NAME);
		getHttpSession().removeAttribute(IS_ADMIN_ATTR_NAME);
	}
	private UserSession()
	{
	}
}
