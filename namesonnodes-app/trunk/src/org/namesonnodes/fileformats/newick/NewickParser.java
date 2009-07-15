package org.namesonnodes.fileformats.newick;

import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import org.namesonnodes.domain.files.BioFileException;

public final class NewickParser
{
	private static String cleanTreeString(final String treeString)
	{
		if (treeString.indexOf('\'') < 0)
			return treeString.replaceAll("\\s+", "");
		String trimmed = treeString.trim();
		if (trimmed.charAt(0) == '\'')
			trimmed = " " + trimmed;
		final String[] sections = trimmed.split("'");
		final int len = sections.length;
		if (len == 0)
			return treeString;
		String cleaned = "";
		for (int i = 0; i < len; i += 2)
		{
			cleaned += sections[i].replaceAll("\\s+", "");
			if (i + 1 < len)
				cleaned += "'" + sections[i + 1] + "'";
		}
		return cleaned;
	}
	private Stack<NewickArc> arcs;
	private int len;
	private int nextVertexIndex = 1;
	private int pos;
	private String[] tokens;
	private Stack<NewickVertex> vertices;
	private void equateHomonymousUnits()
	{
		final Map<String, NewickVertex> map = new HashMap<String, NewickVertex>();
		for (final NewickArc arc : arcs)
		{
			if (arc.head.label != null)
				if (map.containsKey(arc.head.label))
					arc.head = map.get(arc.head.label);
				else
					map.put(arc.head.label, arc.head);
			if (arc.tail.label != null)
				if (map.containsKey(arc.tail.label))
					arc.tail = map.get(arc.tail.label);
				else
					map.put(arc.tail.label, arc.tail);
		}
	}
	private void finalizeVertex(final NewickVertex vertex)
	{
		if (vertex.label == null && vertex.index == 0)
			vertex.index = nextVertexIndex++;
	}
	public Stack<NewickArc> parseToArcStack(final String treeString) throws BioFileException
	{
		arcs = new Stack<NewickArc>();
		vertices = new Stack<NewickVertex>();
		tokens = cleanTreeString(treeString).split("");
		len = tokens.length;
		pos = 1;
		parseVertex();
		for (final NewickArc arc : arcs)
		{
			finalizeVertex(arc.head);
			finalizeVertex(arc.tail);
		}
		equateHomonymousUnits();
		final Stack<NewickArc> result = arcs;
		arcs = null;
		tokens = null;
		return result;
	}
	private void parseVertex() throws BioFileException
	{
		String token = tokens[pos];
		if (pos > len)
			throw new BioFileException("Unexpected end in Newick tree string.");
		final NewickVertex vertex = new NewickVertex();
		if (!vertices.isEmpty())
		{
			final NewickArc arc = new NewickArc(vertices.peek(), vertex);
			arcs.add(arc);
		}
		vertices.push(vertex);
		if (token.equals("("))
		{
			++pos;
			do
			{
				parseVertex();
				if (pos >= len)
					throw new BioFileException("Unexpected end in Newick tree string.");
				token = tokens[pos++];
				if (token.equals(")"))
					break;
				if (!token.equals(","))
					throw new BioFileException("Unexpected character '" + token
					        + "' in Newick tree string at position " + pos + ".");
			} while (true);
		}
		parseVertexLabel();
		vertices.pop();
	}
	private void parseVertexLabel()
	{
		String label = "";
		String weightStr = "";
		while (pos < len)
		{
			final String token = tokens[pos];
			if (token.equals(")") || token.equals(","))
				break;
			++pos;
			label += token;
		}
		if (label.length() == 0)
			return;
		label = label.trim();
		if (label.indexOf(':') >= 0)
			if (label.charAt(0) == ':')
			{
				weightStr = label.substring(1);
				label = "";
			}
			else
			{
				final String[] parts = label.split(":", 2);
				label = parts[0];
				weightStr = parts[1];
			}
		final double weight = weightStr.length() > 0 ? new Double(weightStr) : 0d;
		if (weight != 0d && !arcs.isEmpty())
			arcs.peek().weight = weight;
		if (label.matches("^'.*'$"))
			label = label.substring(1, label.length() - 1).replaceAll("''", "'");
		if (label.length() > 0)
			vertices.peek().label = label;
	}
}
