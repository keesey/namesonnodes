package org.namesonnodes.fileformats.nexus;

import static org.namesonnodes.utils.URIUtil.escape;
import org.biojavax.bio.phylo.io.nexus.TreesBlock;
import org.namesonnodes.fileformats.newick.NewickArcConverter;
import org.namesonnodes.fileformats.newick.NewickVertex;

public final class NexusNewickArcConverter extends NewickArcConverter
{
	private final TreesBlock block;
	private final String treeKey;
	public NexusNewickArcConverter(final TreesBlock block, final String treeKey, final NexusTaxonTable taxonTable)
	{
		super(taxonTable);
		this.block = block;
		this.treeKey = treeKey;
	}
	@Override
	protected String findLocalName(final String[] pieces)
	{
		return TreesBlock.TREES_BLOCK + ":" + escape(treeKey) + ":" + super.findLocalName(pieces);
	}
	@Override
	protected String findVertexLabel(final NewickVertex vertex)
	{
		if (vertex.label == null)
			return null;
		if (block.containsTranslation(vertex.label))
			return (String) block.getTranslations().get(vertex.label);
		return vertex.label;
	}
}