package org.namesonnodes.utils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Static library of collection-related utility methods.
 * 
 * @author T. Michael Keesey
 * @see java.util.Collection
 */
public final class CollectionUtil
{
	public static <K, V> void addToSetMap(final Map<K, Set<V>> map, final K key, final V value)
	{
		if (map.containsKey(key))
			map.get(key).add(value);
		else
			map.put(key, createSingleton(value));
	}
	public static <T> Set<T> createSingleton(final T element)
	{
		final Set<T> set = new HashSet<T>();
		set.add(element);
		return set;
	}
	public static List<String> createStringList(final Object[] array)
	{
		final List<String> list = new ArrayList<String>();
		for (final Object item : array)
			list.add(item.toString());
		return list;
	}
	public static Set<String> createStringSet(final Object[] array)
	{
		final Set<String> set = new HashSet<String>();
		for (final Object item : array)
			set.add(item.toString());
		return set;
	}
	/**
	 * Creates a string by joining the strings of all members of a collection.
	 * 
	 * @param collection
	 *            Collection to join the members of.
	 * @param separator
	 *            String to place between members.
	 * @return A string with all collection members converted to substrings and
	 *         joined by {@code separator}.
	 */
	@SuppressWarnings("unchecked")
	public static String join(final Collection collection, final String separator)
	{
		if (collection == null)
			return "<null>";
		final StringBuilder joined = new StringBuilder();
		final Iterator iter = collection.iterator();
		boolean first = true;
		while (iter.hasNext())
		{
			if (first)
				first = false;
			else
				joined.append(separator);
			joined.append(iter.next().toString());
		}
		return joined.toString();
	}
	/**
	 * (private)
	 */
	private CollectionUtil()
	{
	}
}
