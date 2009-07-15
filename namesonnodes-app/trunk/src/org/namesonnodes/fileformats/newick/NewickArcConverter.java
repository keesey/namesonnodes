package org.namesonnodes.fileformats.newick;

import static org.namesonnodes.utils.ArrayUtil.join;
import static org.namesonnodes.utils.URIUtil.escape;
import java.util.HashMap;
import java.util.Map;
import org.namesonnodes.domain.entities.Heredity;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.fileformats.TaxonConflictException;
import org.namesonnodes.fileformats.TaxonTable;

public class NewickArcConverter
{
	protected static final String ANCESTOR_NAME = "*";
	protected final Map<NewickArc, TaxonIdentifier> branchAncestorTable = new HashMap<NewickArc, TaxonIdentifier>();
	protected final TaxonTable taxonTable;
	protected final Map<NewickVertex, TaxonIdentifier> vertexTable = new HashMap<NewickVertex, TaxonIdentifier>();
	public NewickArcConverter(final TaxonTable taxonTable)
	{
		super();
		this.taxonTable = taxonTable;
	}
	public final Heredity convert(final NewickArc newickArc) throws TaxonConflictException
	{
		final TaxonIdentifier nodeAncestor = convert(newickArc.head);
		final TaxonIdentifier descendant = convert(newickArc.tail);
		return new Heredity(nodeAncestor, descendant, newickArc.weight);
	}
	private TaxonIdentifier convert(final NewickVertex vertex) throws TaxonConflictException
	{
		if (vertexTable.containsKey(vertex))
			return vertexTable.get(vertex);
		final String label = findVertexLabel(vertex);
		if (label != null && label.length() != 0)
		{
			final TaxonIdentifier taxonIdentifier = taxonTable.getTaxon(label);
			vertexTable.put(vertex, taxonIdentifier);
			return taxonIdentifier;
		}
		final String[] localNamePieces = { "HTU", Integer.toHexString(vertex.index) };
		final String localName = findLocalName(localNamePieces);
		final String name = ANCESTOR_NAME;
		final Taxon entity = new Taxon();
		final TaxonIdentifier taxon = new TaxonIdentifier();
		taxon.setAuthority(taxonTable.getAuthority());
		taxon.setEntity(entity);
		taxon.getLabel().setName(name);
		taxon.setLocalName(localName);
		vertexTable.put(vertex, taxon);
		taxonTable.put(taxon);
		return taxon;
	}
	protected String findLocalName(final String[] pieces)
	{
		return join(escape(pieces), ":");
	}
	protected String findShortVertexName(final NewickVertex vertex)
	{
		if (vertex.label != null && vertex.label.length() != 0)
			return vertex.label;
		if (vertex.index > 0)
			return Integer.toHexString(vertex.index);
		return Integer.toHexString(vertex.hashCode());
	}
	protected String findVertexLabel(final NewickVertex vertex)
	{
		return vertex.label;
	}
}