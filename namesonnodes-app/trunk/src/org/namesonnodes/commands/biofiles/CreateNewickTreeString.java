package org.namesonnodes.commands.biofiles;

import static flex.messaging.FlexContext.getHttpRequest;
import static org.hibernate.criterion.Restrictions.eq;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Stack;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.Authority;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.domain.files.BioFileException;
import org.namesonnodes.fileformats.TaxonConflictException;
import org.namesonnodes.fileformats.TaxonTable;
import org.namesonnodes.fileformats.newick.NewickArc;
import org.namesonnodes.fileformats.newick.NewickArcConverter;
import org.namesonnodes.fileformats.newick.NewickParser;

public final class CreateNewickTreeString extends AbstractCommand<BioFile>
{
	private static final long serialVersionUID = -8360684213621053450L;
	protected static final String AUTHORITY_PREFIX = "Newick #";
	protected static final String DATASET_PREFIX = "Network: ";
	protected static final String LOCAL_NAME = "network";
	private static String createNameFromList(final List<String> otuNames, final int maxLength)
	{
		String name = "";
		for (final String otuName : otuNames)
		{
			final String newName = name + (name.length() == 0 ? "" : ", ") + otuName;
			if (newName.length() > maxLength - 3)
			{
				name += "...";
				break;
			}
			name = newName;
		}
		return name.replace('_', ' ');
	}
	private String abbr = null;
	private boolean commitRequired = false;
	private String name = null;
	private String treeString;
	private double weightPerGeneration = 0.0;
	private double weightPerYear = 0.0;
	public CreateNewickTreeString()
	{
		super();
	}
	public CreateNewickTreeString(final String treeString)
	{
		super();
		setTreeString(treeString);
	}
	public CreateNewickTreeString(final String treeString, final String name)
	{
		this(treeString);
		setName(name);
	}
	public CreateNewickTreeString(final String treeString, final String name, final String abbr)
	{
		this(treeString, name);
		setAbbr(abbr);
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "treeString", "abbr", "name" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { treeString, abbr, name };
		return v;
	}
	@Override
	protected BioFile doExecute(final Session session) throws CommandException
	{
		if (treeString == null || treeString.length() == 0)
			throw new CommandException("No Newick tree string provided.");
		final BioFile file = new BioFile();
		try
		{
			file.setSource(treeString.toCharArray());
		}
		catch (final IOException ex)
		{
			throw new CommandException(ex);
		}
		catch (final NoSuchAlgorithmException ex)
		{
			throw new CommandException(ex);
		}
		final BioFile existingFile = (BioFile) session.createCriteria(BioFile.class).add(
		        eq("sourceHash", file.getSourceHash())).uniqueResult();
		if (existingFile != null)
			return existingFile;
		final AuthorityIdentifier authorityIdentifier = new AuthorityIdentifier();
		authorityIdentifier.setEntity(new Authority());
		file.setAuthority(authorityIdentifier);
		file.setIpAddress(getHttpRequest() == null ? "0.0.0.0" : getHttpRequest().getRemoteAddr());
		file.setTimeUploaded(new Date());
		if (abbr == null)
		{
			if (name == null || name.length() > AUTHORITY_PREFIX.length() + 9)
				authorityIdentifier.getEntity().getLabel().setAbbr(
				        AUTHORITY_PREFIX + file.getSourceHash().substring(0, 6) + "...");
		}
		else
			authorityIdentifier.getEntity().getLabel().setAbbr(abbr);
		if (name == null)
			authorityIdentifier.getEntity().getLabel().setName(AUTHORITY_PREFIX + file.getSourceHash());
		else
			authorityIdentifier.getEntity().getLabel().setName(name);
		authorityIdentifier.setUri(file.toURI());
		if (authorityIdentifier == null)
			throw new CommandException("Cannot find authority.");
		final NewickParser parser = new NewickParser();
		try
		{
			final Stack<NewickArc> arcs = parser.parseToArcStack(treeString);
			if (arcs.isEmpty())
				throw new CommandException("No arcs.");
			final Dataset dataset = new Dataset();
			dataset.setAuthority(authorityIdentifier);
			dataset.setLocalName(LOCAL_NAME);
			dataset.setWeightPerGeneration(weightPerGeneration);
			dataset.setWeightPerYear(weightPerYear);
			final NewickArcConverter converter = new NewickArcConverter(new TaxonTable(session, authorityIdentifier));
			final List<String> otuNames = new ArrayList<String>();
			for (final NewickArc arc : arcs)
			{
				if (arc.tail.label != null && arc.tail.label.length() != 0 && !otuNames.contains(arc.tail.label))
					otuNames.add(arc.tail.label);
				try
				{
					dataset.getHeredities().add(converter.convert(arc));
				}
				catch (final TaxonConflictException ex)
				{
					throw new CommandException(ex);
				}
			}
			dataset.getLabel().setAbbr(DATASET_PREFIX + createNameFromList(otuNames, 64 - DATASET_PREFIX.length()));
			dataset.getLabel().setName(DATASET_PREFIX + createNameFromList(otuNames, 256 - DATASET_PREFIX.length()));
			// session.merge(authorityIdentifier);
			session.save(dataset);
			session.save(file);
			commitRequired = true;
		}
		catch (final BioFileException ex)
		{
			commitRequired = false;
			throw new CommandException(ex);
		}
		return file;
	}
	public final String getAbbr()
	{
		return abbr;
	}
	public final String getName()
	{
		return name;
	}
	public String getTreeString()
	{
		return treeString;
	}
	public final double getWeightPerGeneration()
	{
		return weightPerGeneration;
	}
	public double getWeightPerYear()
	{
		return weightPerYear;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setAbbr(final String abbr)
	{
		this.abbr = abbr == "" ? null : abbr;
	}
	public final void setName(final String name)
	{
		this.name = name == "" ? null : name;
	}
	public void setTreeString(final String treeString)
	{
		this.treeString = treeString;
	}
	public final void setWeightPerGeneration(final double weightPerGeneration)
	{
		this.weightPerGeneration = weightPerGeneration;
	}
	public void setWeightPerYear(final double weightPerYear)
	{
		this.weightPerYear = weightPerYear;
	}
}
