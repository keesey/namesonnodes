package org.namesonnodes.html;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.authorization.FindBioFiles;
import org.namesonnodes.commands.authorization.FindDatasets;
import org.namesonnodes.commands.authorization.FindTaxa;
import org.namesonnodes.commands.wrap.WrapEntity;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Dataset;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.domain.files.BioFile;
import org.namesonnodes.resolve.uris.TotalURIResolver;

public final class AuthorityIdentifierAssistant implements EntityHTMLAssistant<AuthorityIdentifier>
{
	private final Session session;
	public AuthorityIdentifierAssistant(final Session session)
	{
		super();
		this.session = session;
	}
	public String getAbstract(final AuthorityIdentifier entity)
	{
		String abs = "<b><code>"
		        + entity.getUri()
		        + "</code></b> is an <b>authority identifier</b>, identifying the authority <a href=\"/namesonnodes/entity/authority:"
		        + entity.getEntity().getId() + "\">" + entity.getEntity().getLabel().toHTMLText() + "</a>";
		abs += " Authorities may authorize (or qualify) both taxon identifiers and datasets.";
		return abs;
	}
	public String getClassName()
	{
		return "Authority Identifier";
	}
	public String getDescription(final AuthorityIdentifier entity)
	{
		return entity.getUri() + " is an authority identifier in the Names on Nodes database.";
	}
	public List<Link> getEntityLinks(final AuthorityIdentifier entity)
	{
		final List<Link> links = new ArrayList<Link>();
		links.add(new Link("/namesonnodes/entity/authority:" + entity.getEntity().getId(), entity.getEntity()
		        .getLabel().toHTMLText(), " is the authority identified by this entity."));
		final Command<AuthorityIdentifier> entityCommand = new WrapEntity<AuthorityIdentifier>(entity);
		Set<TaxonIdentifier> taxonIdentifiers;
		Set<Dataset> datasets;
		Set<BioFile> bioFiles;
		try
		{
			taxonIdentifiers = new FindTaxa(entityCommand).execute(session);
			datasets = new FindDatasets(entityCommand).execute(session);
			bioFiles = new FindBioFiles(entityCommand).execute(session);
		}
		catch (final CommandException e)
		{
			throw new RuntimeException(e);
		}
		for (final BioFile bioFile : bioFiles)
			links.add(new Link("/namesonnodes/entity/biofile/?id=" + bioFile.getId(),
			        "This identifier is associated with a bioinformatics file.",
			        " Click on the link to download the file."));
		for (final Dataset dataset : datasets)
			links.add(new Link("/namesonnodes/entity/dataset:" + dataset.getId(), dataset.getLabel().toHTMLText(),
			        " is a dataset which is authorized (qualified) by this identifier's authority."));
		for (final TaxonIdentifier identifier : taxonIdentifiers)
			links.add(new Link("/namesonnodes/entity/taxonidentifier:" + identifier.getId(), identifier.getLabel()
			        .toHTMLText(),
			        " is a taxon identifier which is authorized (qualified) by this identifier's authority."));
		return links;
	}
	public List<Link> getExternalLinks(final AuthorityIdentifier entity)
	{
		URL url;
		try
		{
			url = TotalURIResolver.INSTANCE.resolve(new URI(entity.getUri()));
		}
		catch (final URISyntaxException e)
		{
			url = null;
		}
		final Link link = new Link();
		link.url = url == null ? entity.getUri() : url.toString();
		link.linkText = "<code>" + entity.getUri() + "</code>";
		final List<Link> links = new ArrayList<Link>();
		links.add(link);
		return links;
	}
	public String getExtraContent(final AuthorityIdentifier entity)
	{
		return "";
	}
	public String getHeader(final AuthorityIdentifier entity)
	{
		return "<h1><code>" + entity.getUri() + "</code></h1>";
	}
	public Set<String> getKeywords(final AuthorityIdentifier entity)
	{
		final Set<String> keywords = new HashSet<String>();
		keywords.add("authority");
		keywords.add("authorities");
		keywords.add("authorize");
		keywords.add("authorization");
		keywords.add("bioinformatics");
		keywords.add("file");
		keywords.add("identifier");
		keywords.add("identification");
		keywords.add("identify");
		keywords.add("identity");
		keywords.add("nexus");
		keywords.add("nexml");
		keywords.add("phyloxml");
		keywords.add(entity.getEntity().getLabel().getName());
		if (entity.getEntity().getLabel().getAbbr() != null)
			keywords.add(entity.getEntity().getLabel().getAbbr());
		return keywords;
	}
	public String getName(final AuthorityIdentifier entity)
	{
		return entity.getUri();
	}
	public String getTableName()
	{
		return "authorityidentifier";
	}
}
