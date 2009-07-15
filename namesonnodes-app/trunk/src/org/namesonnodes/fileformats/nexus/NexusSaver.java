package org.namesonnodes.fileformats.nexus;

import static org.hibernate.criterion.Restrictions.eq;
import static org.namesonnodes.fileformats.InclusionInference.inferInclusions;
import static org.namesonnodes.utils.CollectionUtil.addToSetMap;
import static org.namesonnodes.utils.URIUtil.escape;
import java.io.CharArrayWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.security.NoSuchAlgorithmException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;
import java.util.Stack;
import org.biojava.bio.seq.io.ParseException;
import org.biojavax.bio.phylo.io.nexus.CharactersBlock;
import org.biojavax.bio.phylo.io.nexus.NexusBlock;
import org.biojavax.bio.phylo.io.nexus.NexusComment;
import org.biojavax.bio.phylo.io.nexus.NexusFile;
import org.biojavax.bio.phylo.io.nexus.NexusFileBuilder;
import org.biojavax.bio.phylo.io.nexus.NexusFileFormat;
import org.biojavax.bio.phylo.io.nexus.NexusObject;
import org.biojavax.bio.phylo.io.nexus.TaxaBlock;
import org.biojavax.bio.phylo.io.nexus.TreesBlock;
import org.biojavax.bio.phylo.io.nexus.TreesBlock.NewickTreeString;
import org.hibernate.Session;
import org.namesonnodes.domain.DuplicateException;
import org.namesonnodes.domain.Persistent;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.Heredity;
import org.namesonnodes.domain.entities.Inclusion;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.domain.files.BioFileException;
import org.namesonnodes.fileformats.TaxonTable;
import org.namesonnodes.fileformats.newick.NewickArc;
import org.namesonnodes.fileformats.newick.NewickParser;

public final class NexusSaver
{
	protected static final String BLOCK_DATA_TYPE_STANDARD = "STANDARD";
	protected static final String COMMENT_PREFIX = "NEXUS: ";
	protected static final String HASH_PREFIX = "NEXUS #";
	protected static final String TREE_UNROOTED = "U";
	private static Dataset buildDataset(final AuthorityIdentifier authority, final String blockType, final String label)
	{
		final String adjustedLabel = label.replace('_', ' ');
		final String localName = blockType.equals(label) ? label : blockType + ":" + escape(adjustedLabel);
		final Dataset dataset = new Dataset();
		dataset.setAuthority(authority);
		dataset.setLocalName(localName);
		dataset.getLabel().setName(adjustedLabel);
		return dataset;
	}
	private static NexusFile buildNexusFile(final Reader reader) throws BioFileException
	{
		final NexusFileBuilder builder = new NexusFileBuilder();
		try
		{
			NexusFileFormat.parseReader(builder, reader);
		}
		catch (final IOException ex)
		{
			throw new BioFileException(ex);
		}
		catch (final ParseException ex)
		{
			throw new BioFileException(ex);
		}
		final NexusFile nexusFile = builder.getNexusFile();
		if (nexusFile == null)
			throw new BioFileException(new NullPointerException("NEXUS data could not be read."));
		return nexusFile;
	}
	private static void equateAncestors(final Collection<TaxonIdentifier> taxonIdentifiers,
	        final Collection<Heredity> heredities, final Set<Dataset> networks)
	{
		final Set<Taxon> entities = new HashSet<Taxon>();
		for (final TaxonIdentifier taxonIdentifier : taxonIdentifiers)
			entities.add(taxonIdentifier.getEntity());
		final Set<Taxon> localEntities = new HashSet<Taxon>();
		if (networks.size() > 1)
			for (final Dataset network : networks)
			{
				final Set<Taxon> taxa = network.collectTaxa();
				for (final Taxon entity : entities)
					if (!taxa.contains(entity))
						localEntities.add(entity);
			}
		final Map<Taxon, Set<Taxon>> descendants = new HashMap<Taxon, Set<Taxon>>();
		for (final Taxon entity : entities)
			if (!descendants.containsKey(entity))
			{
				final Set<Taxon> set = findDescendants(entity, heredities, descendants);
				descendants.put(entity, set);
			}
		Map<Taxon, Set<Taxon>> globalDescendants;
		if (localEntities.isEmpty())
			globalDescendants = descendants;
		else
		{
			globalDescendants = new HashMap<Taxon, Set<Taxon>>();
			for (final Taxon identity : descendants.keySet())
			{
				final Set<Taxon> set = new HashSet<Taxon>();
				set.addAll(descendants.get(identity));
				set.removeAll(localEntities);
				globalDescendants.put(identity, set);
			}
		}
		final Set<Taxon> deprecatedIdentities = new HashSet<Taxon>();
		for (final Taxon entity : entities)
		{
			if (deprecatedIdentities.contains(entity))
				continue;
			for (final TaxonIdentifier taxonIdentifier : taxonIdentifiers)
			{
				final Taxon otherEntity = taxonIdentifier.getEntity();
				if (entity != otherEntity)
				{
					if (deprecatedIdentities.contains(otherEntity))
						continue;
					final Set<Taxon> set = globalDescendants.get(entity);
					if (!set.isEmpty() && set.equals(globalDescendants.get(otherEntity)))
						if (!descendants.get(entity).contains(otherEntity)
						        && !descendants.get(otherEntity).contains(entity))
						{
							taxonIdentifier.setEntity(entity);
							deprecatedIdentities.add(otherEntity);
						}
				}
			}
		}
	}
	private static void finalizeAuthority(final AuthorityIdentifier authorityIdentifier, final String comments,
	        final BioFile file, final Collection<TaxonIdentifier> taxonIdentifiers)
	{
		if (comments.length() >= 8)
		{
			String name = COMMENT_PREFIX + comments;
			if (name.length() > 256)
				name = name.substring(0, 256);
			authorityIdentifier.getEntity().getLabel().setName(name);
			if (name.length() > 64)
				authorityIdentifier.getEntity().getLabel().setAbbr(name.substring(0, 61) + "...");
		}
		else
		{
			authorityIdentifier.getEntity().getLabel().setName(HASH_PREFIX + file.getSourceHash());
			authorityIdentifier.getEntity().getLabel().setAbbr(
			        HASH_PREFIX + file.getSourceHash().substring(0, 8) + "...");
		}
		authorityIdentifier.setUri(file.toURI());
	}
	private static Set<Taxon> findDescendants(final Taxon identity, final Collection<Heredity> heredities,
	        final Map<Taxon, Set<Taxon>> descendants)
	{
		if (descendants.containsKey(identity))
			return descendants.get(identity);
		final Set<Taxon> d = new HashSet<Taxon>();
		for (final Heredity heredity : heredities)
			if (heredity.getPredecessor().getEntity() == identity)
			{
				final Taxon otherIdentity = heredity.getSuccessor().getEntity();
				d.add(otherIdentity);
				d.addAll(findDescendants(otherIdentity, heredities, descendants));
			}
		descendants.put(identity, d);
		return d;
	}
	private static void readTaxaBlock(final TaxaBlock block, final TaxonTable taxonTable)
	{
		readTaxLabelIter(block.getTaxLabels().listIterator(), taxonTable);
	}
	@SuppressWarnings("unchecked")
	private static void readTaxLabelIter(final Iterator iter, final TaxonTable taxonTable)
	{
		while (iter.hasNext())
		{
			final String label = (String) iter.next();
			taxonTable.getTaxon(label);
		}
	}
	@SuppressWarnings("unchecked")
	private static char[] writeSource(final NexusFile nexusFile)
	{
		if (nexusFile == null)
			return new char[0];
		final CharArrayWriter writer = new CharArrayWriter(1024);
		try
		{
			writer.write("#NEXUS" + NexusFileFormat.NEW_LINE);
			final Iterator iter = nexusFile.objectIterator();
			while (iter.hasNext())
			{
				((NexusObject) iter.next()).writeObject(writer);
				writer.write(NexusFileFormat.NEW_LINE);
			}
		}
		catch (final IOException ex)
		{
			throw new RuntimeException(ex);
		}
		return writer.toCharArray();
	}
	private final Set<Persistent> itemsToPersist = new HashSet<Persistent>();
	// private static final Collection<Inclusion> inclusions = new
	// ArrayList<Inclusion>();
	private final Map<TaxonIdentifier, Set<TaxonIdentifier>> scoreMap = new HashMap<TaxonIdentifier, Set<TaxonIdentifier>>();
	@SuppressWarnings("unchecked")
	private Inclusion processState(final String state, final TaxonIdentifier taxon, final Integer characterIndex,
	        final CharactersBlock block, final TaxonTable taxonTable)
	{
		if (state == null || state.length() == 0)
			return null;
		String label = "";
		try
		{
			label = (String) block.getStateLabels(characterIndex.toString()).get(Integer.valueOf(state));
		}
		catch (final Exception ex)
		{
			// Ignore.
		}
		if (label.length() == 0)
			label = state;
		String charLabel = "";
		final List charLabels = block.getCharLabels();
		if (charLabels == null || charLabels.size() < characterIndex)
			charLabel = Integer.toString(characterIndex);
		else
			charLabel = charLabels.get(characterIndex - 1).toString();
		final TaxonIdentifier stateIdentifier = taxonTable.getState(charLabel, label);
		final Inclusion inclusion = new Inclusion(stateIdentifier, taxon);
		addToSetMap(scoreMap, stateIdentifier, taxon);
		return inclusion;
	}
	@SuppressWarnings("unchecked")
	private void readCharactersBlock(final CharactersBlock block, final TaxonTable taxonTable) throws BioFileException
	{
		readTaxLabelIter(block.getTaxLabels().listIterator(), taxonTable);
		readTaxLabelIter(block.getMatrixLabels().iterator(), taxonTable);
		if (block.getDataType().equalsIgnoreCase(BLOCK_DATA_TYPE_STANDARD))
		{
			final Dataset matrix = buildDataset(taxonTable.getAuthority(), block.getBlockName(), block.getBlockName());
			final Collection<TaxonIdentifier> taxa = new HashSet<TaxonIdentifier>(taxonTable.values());
			final Map<TaxonIdentifier, Set<TaxonIdentifier>> inclusions = new HashMap<TaxonIdentifier, Set<TaxonIdentifier>>();
			final Map<TaxonIdentifier, Set<TaxonIdentifier>> normalizedInclusions = new HashMap<TaxonIdentifier, Set<TaxonIdentifier>>();
			for (final TaxonIdentifier taxon : taxa)
			{
				List scores = block.getMatrixData(taxon.getLocalName().substring(5));
				if (scores == null)
					scores = block.getMatrixData(taxon.getLabel().getName());
				final ListIterator statesIter = scores.listIterator(1);
				while (statesIter.hasNext())
				{
					final Integer characterIndex = statesIter.nextIndex();
					final Object states = statesIter.next();
					if (states instanceof String)
					{
						final Inclusion inclusion = processState(states.toString(), taxon, characterIndex, block,
						        taxonTable);
						if (inclusion != null)
						{
							addToSetMap(inclusions, inclusion.getSuperset(), inclusion.getSubset());
							addToSetMap(normalizedInclusions, inclusion.getSuperset(), inclusion.getSubset());
						}
					}
					else if (states instanceof List)
						for (final Object state : (List) states)
						{
							final Inclusion inclusion = processState(state.toString(), taxon, characterIndex, block,
							        taxonTable);
							if (inclusion != null)
							{
								addToSetMap(inclusions, inclusion.getSuperset(), inclusion.getSubset());
								addToSetMap(normalizedInclusions, inclusion.getSuperset(), inclusion.getSubset());
								// matrix.getRelations().add(inclusion);
							}
						}
					else
						throw new BioFileException("Unexpected state type: " + states.getClass().getName());
				}
			}
			// Normalize inclusions.
			for (final TaxonIdentifier a : inclusions.keySet())
			{
				final Set<TaxonIdentifier> aSub = inclusions.get(a);
				if (!aSub.isEmpty())
					for (final TaxonIdentifier b : inclusions.keySet())
						if (a != b)
						{
							final Set<TaxonIdentifier> bSub = inclusions.get(b);
							if (!bSub.isEmpty() && aSub.size() > bSub.size() && aSub.containsAll(bSub))
							{
								normalizedInclusions.get(a).removeAll(bSub);
								normalizedInclusions.get(a).add(b);
							}
						}
			}
			// Translate inclusions.
			for (final TaxonIdentifier a : normalizedInclusions.keySet())
				for (final TaxonIdentifier b : normalizedInclusions.get(a))
				{
					final Inclusion inclusion = new Inclusion(a, b);
					matrix.getInclusions().add(inclusion);
				}
			// Persist matrix.
			itemsToPersist.add(matrix);
		}
	}
	private void readNexusBlock(final NexusBlock block, final NexusTaxonTable taxonTable) throws BioFileException
	{
		if (block instanceof CharactersBlock)
			readCharactersBlock((CharactersBlock) block, taxonTable);
		else if (block instanceof TaxaBlock)
			readTaxaBlock((TaxaBlock) block, taxonTable);
		else if (block instanceof TreesBlock)
			readTreesBlock((TreesBlock) block, taxonTable);
	}
	@SuppressWarnings("unchecked")
	private void readNexusBlocks(final NexusFile nexusFile, final NexusTaxonTable taxonTable) throws BioFileException
	{
		scoreMap.clear();
		final Iterator blockIter = nexusFile.blockIterator();
		while (blockIter.hasNext())
		{
			final NexusBlock block = (NexusBlock) blockIter.next();
			readNexusBlock(block, taxonTable);
		}
		scoreMap.clear();
	}
	@SuppressWarnings("unchecked")
	private void readNexusComments(final Iterator iter, final Writer writer) throws IOException
	{
		while (iter.hasNext())
		{
			final Object item = iter.next();
			if (item instanceof NexusComment)
				readNexusComments(((NexusComment) item).commentIterator(), writer);
			else
				writer.write(item.toString());
		}
	}
	private String readNexusComments(final NexusFile nexusFile) throws IOException
	{
		final StringWriter writer = new StringWriter();
		readNexusComments(nexusFile.commentIterator(), writer);
		return writer.toString();
	}
	@SuppressWarnings("unchecked")
	private void readTreesBlock(final TreesBlock block, final NexusTaxonTable taxonTable) throws BioFileException
	{
		final Set<Dataset> networks = new HashSet<Dataset>();
		final Iterator keyIter = block.getTrees().keySet().iterator();
		final Collection<Heredity> allParentages = new HashSet<Heredity>();
		final Map<Dataset, Set<Heredity>> treeParentageMap = new HashMap<Dataset, Set<Heredity>>();
		while (keyIter.hasNext())
		{
			final NewickParser treeParser = new NewickParser();
			final Set<Heredity> treeParentages = new HashSet<Heredity>();
			final String key = keyIter.next().toString();
			final NewickTreeString treeString = (NewickTreeString) block.getTrees().get(key);
			// System.out.println(key + ": " + treeString.getTreeString());
			// System.out.println("\tprocessing arcs...");
			if (treeString.getRootType() != TREE_UNROOTED)
			{
				final Stack<NewickArc> arcs = treeParser.parseToArcStack(treeString.getTreeString());
				if (arcs.isEmpty())
					throw new BioFileException("Empty Newick tree.");
				final Dataset network = buildDataset(taxonTable.getAuthority(), block.getBlockName(), key);
				final NexusNewickArcConverter nexusNewickArcConverter = new NexusNewickArcConverter(block, key,
				        taxonTable);
				try
				{
					do
						treeParentages.add(nexusNewickArcConverter.convert(arcs.pop()));
					while (!arcs.isEmpty());
				}
				catch (final Exception ex)
				{
					throw new BioFileException(ex);
				}
				treeParentageMap.put(network, treeParentages);
				network.getHeredities().addAll(treeParentages);
				allParentages.addAll(treeParentages);
				// System.out.println("\tinferring inclusions...");
				// network.getRelations().addAll(inferInclusions(inclusions,
				// treeParentages));
				networks.add(network);
				// System.out.println("Tree complete: " + key);
			}
		}
		// System.out.println("Equating ancestors...");
		equateAncestors(taxonTable.values(), allParentages, networks);
		// System.out.println("Completed equating ancestors.");
		// System.out.println("Inferring inclusions...");
		for (final Dataset network : networks)
			// System.out.println("\t" + network.getName() + "...");
			network.getInclusions().addAll(inferInclusions(scoreMap, treeParentageMap.get(network)));
		// System.out.println("Inclusions inferred.");
		treeParentageMap.clear();
		// System.out.println("Persisting trees...");
		for (final Dataset network : networks)
			// System.out.println("\t" + network.getName() + "...");
			itemsToPersist.add(network);
	}
	public BioFile save(final Session session, final InputStream stream, final String ipAddress)
	        throws BioFileException, DuplicateException, NoSuchAlgorithmException, IOException
	{
		return save(session, new InputStreamReader(stream), ipAddress);
	}
	@SuppressWarnings("unchecked")
	public BioFile save(final Session session, final Reader reader, final String ipAddress) throws BioFileException,
	        DuplicateException, NoSuchAlgorithmException, IOException
	{
		final AuthorityIdentifier authorityIdentifier = new AuthorityIdentifier();
		authorityIdentifier.setEntity(new Authority());
		final NexusTaxonTable taxonTable = new NexusTaxonTable(session, authorityIdentifier);
		final NexusFile nexusFile = buildNexusFile(reader);
		final String comments = readNexusComments(nexusFile).replaceAll("\\s+", " ").replace('!', ' ').trim();
		readNexusBlocks(nexusFile, taxonTable);
		final BioFile bioFile = new BioFile(authorityIdentifier, ipAddress, writeSource(nexusFile));
		final List duplicates = session.createCriteria(BioFile.class).add(eq("sourceHash", bioFile.getSourceHash()))
		        .list();
		if (duplicates.size() > 0)
			throw new DuplicateException(((Persistent) duplicates.get(0)).getId());
		finalizeAuthority(authorityIdentifier, comments, bioFile, taxonTable.values());
		session.save(bioFile);
		for (final Persistent item : itemsToPersist)
			session.save(item);
		return bioFile;
	}
}
