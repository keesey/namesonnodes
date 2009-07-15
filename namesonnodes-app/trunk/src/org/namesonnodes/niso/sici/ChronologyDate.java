package org.namesonnodes.niso.sici;

import static org.namesonnodes.utils.CollectionUtil.join;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.namesonnodes.niso.NISOException;

public final class ChronologyDate
{
	public static int APRIL = 4;
	public static int AUGUST = 8;
	public static int DECEMBER = 12;
	public static int FALL = 23;
	public static int FEBRUARY = 2;
	public static int JANUARY = 1;
	public static int JULY = 7;
	public static int JUNE = 6;
	public static int MARCH = 3;
	public static int MAY = 5;
	public static final String[] MONTH_NAMES = { "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",
	        "Oct", "Nov", "Dec" };
	public static int NOVEMBER = 11;
	public static int OCTOBER = 10;
	public static int Q1 = 31;
	public static int Q2 = 32;
	public static int Q3 = 33;
	public static int Q4 = 34;
	public static final String[] SEASON_NAMES = { "", "Spring", "Summer", "Fall", "Winter" };
	public static int SEPTEMBER = 9;
	public static int SPRING = 21;
	public static int SUMMER = 22;
	public static int WINTER = 24;
	private static String pad(final int i, final int size)
	{
		String s = Integer.toString(i);
		while (s.length() < size)
			s = "0" + s;
		return s;
	}
	private int day;
	private int month;
	private int quarter;
	private int season;
	private int year;
	public ChronologyDate()
	{
		super();
	}
	public ChronologyDate(final int year)
	{
		super();
		this.year = year;
	}
	public ChronologyDate(final int year, final int monthSeasonOrQuarter)
	{
		super();
		this.year = year;
		if (monthSeasonOrQuarter > 30)
			this.quarter = monthSeasonOrQuarter;
		else if (monthSeasonOrQuarter > 20)
			this.season = monthSeasonOrQuarter;
		else
			this.month = monthSeasonOrQuarter;
	}
	public ChronologyDate(final int year, final int month, final int day)
	{
		super();
		this.year = year;
		this.month = month;
		this.day = day;
	}
	public ChronologyDate(final String source, final ChronologyDate previous) throws NISOException
	{
		super();
		if (previous != null)
			previous.normalize();
		if (source != null && source.length() != 0)
		{
			if (!source.matches("^[0-9]+$"))
				throw new NISOException("Invalid chronology date: '" + source + "'.");
			final int n = source.length();
			if (n == 2 && previous != null && previous.year != 0)
				if (previous.day != 0)
				{
					year = previous.year;
					month = previous.month;
					day = new Integer(source);
				}
				else
				{
					year = previous.year;
					month = new Integer(source);
				}
			if (n == 4)
			{
				if (previous != null && previous.year != 0 && previous.month != 0 && previous.day != 0)
				{
					year = previous.year;
					month = new Integer(source.substring(0, 2));
					day = new Integer(source.substring(2));
				}
				else
					year = new Integer(source);
			}
			else if (n == 6)
			{
				year = new Integer(source.substring(0, 4));
				final int msq = new Integer(source.substring(4));
				if (msq > 30)
				{
					quarter = msq;
					season = 0;
					month = 0;
				}
				else if (msq > 20)
				{
					season = msq;
					quarter = 0;
					month = 0;
				}
				else
				{
					month = msq;
					quarter = 0;
					season = 0;
				}
				day = 0;
			}
			else if (n == 8)
			{
				year = new Integer(source.substring(0, 4));
				month = new Integer(source.substring(4, 6));
				day = new Integer(source.substring(6));
			}
			else
				throw new NISOException("Invalid chronology date: '" + source + "'.");
			normalize();
		}
		else
			copy(previous);
	}
	public void copy(final ChronologyDate date)
	{
		if (date == null)
			return;
		date.normalize();
		day = date.day;
		month = date.month;
		quarter = date.quarter;
		season = date.season;
		year = date.year;
	}
	public final int getDay()
	{
		normalize();
		return day;
	}
	public final int getMonth()
	{
		normalize();
		return month;
	}
	public final int getQuarter()
	{
		normalize();
		return quarter;
	}
	public final int getSeason()
	{
		normalize();
		return season;
	}
	public final int getYear()
	{
		normalize();
		return year;
	}
	private void normalize()
	{
		final Calendar date = Calendar.getInstance();
		if (year != 0)
		{
			date.set(Calendar.YEAR, year);
			if (month != 0)
			{
				date.set(Calendar.MONTH, month - 1);
				if (day != 0)
				{
					date.set(Calendar.DAY_OF_MONTH, day);
					day = date.get(Calendar.DAY_OF_MONTH);
				}
				month = date.get(Calendar.MONTH) + 1;
				season = 0;
				quarter = (month - 1) / 4;
			}
			else
			{
				day = 0;
				if (quarter != 0)
					season = 0;
				else if (season != 0)
					quarter = 0;
			}
			year = date.get(Calendar.YEAR);
		}
	}
	public final void setDay(final int day)
	{
		this.day = day < 0 || day > 31 ? 0 : day;
	}
	public final void setMonth(final int month)
	{
		this.month = month < 0 || month > 12 ? 0 : month;
	}
	public final void setQuarter(final int quarter)
	{
		this.quarter = quarter < 0 || quarter > 4 ? 0 : quarter;
	}
	public final void setSeason(final int season)
	{
		this.season = season < 0 || season > 4 ? 0 : season;
	}
	public final void setYear(final int year)
	{
		this.year = year < 0 || year > 9999 ? 0 : year;
	}
	public String toChronologyString()
	{
		return join(toChronologyStringParts(), "");
	}
	public String toChronologyString(final ChronologyDate previousDate)
	{
		if (previousDate == null)
			return toChronologyString();
		final List<String> parts = toChronologyStringParts();
		final List<String> prevParts = previousDate.toChronologyStringParts();
		final int n = parts.size();
		final int n2 = prevParts.size();
		int i = 0;
		for (; i < n && i < n2; ++i)
			if (!parts.get(i).equals(prevParts.get(i)))
				break;
		return join(parts.subList(i, n), "");
	}
	protected List<String> toChronologyStringParts()
	{
		normalize();
		final List<String> parts = new ArrayList<String>();
		if (year != 0)
		{
			parts.add(pad(year, 4));
			if (month != 0)
			{
				parts.add(pad(month, 2));
				if (day != 0)
					parts.add(pad(day, 2));
			}
			else if (quarter != 0)
				parts.add(pad(30 + quarter, 2));
			else if (season != 0)
				parts.add(pad(20 + quarter, 2));
		}
		return parts;
	}
	public String toLabelString()
	{
		normalize();
		final List<String> parts = new ArrayList<String>();
		if (year != 0)
		{
			parts.add(new Integer(year).toString());
			if (month != 0)
			{
				parts.add(MONTH_NAMES[month]);
				if (day != 0)
					parts.add(new Integer(day).toString());
			}
			else if (quarter != 0)
				parts.add("Q" + (quarter - 30));
			else if (season != 0)
				parts.add(SEASON_NAMES[season - 20]);
		}
		return join(parts, " ");
	}
	@Override
	public String toString()
	{
		return join(toChronologyStringParts(), "-");
	}
}
