package org.namesonnodes.commands.specimens;

import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.SpecimenDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;
import org.namesonnodes.utils.URIUtil;

public final class CreateSpecimen extends AbstractCommand<TaxonIdentifier>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2350770262664794438L;
	private Command<AuthorityIdentifier> catalogueCommand;
	private boolean commitRequired = false;
	private String identifier;
	public CreateSpecimen()
	{
		super();
	}
	public CreateSpecimen(final Command<AuthorityIdentifier> catalogueCommand, final String identifier)
	{
		super();
		this.catalogueCommand = catalogueCommand;
		this.identifier = identifier;
	}
	@Override
	protected String[] attributeNames()
	{
		final String[] a = { "catalogue", "identifier" };
		return a;
	}
	@Override
	protected Object[] attributeValues()
	{
		final Object[] v = { catalogueCommand, identifier };
		return v;
	}
	@Override
	protected TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (identifier == null || identifier.length() == 0)
			throw new CommandException("No identifier.");
		final AuthorityIdentifier catalogue = acquire(catalogueCommand, session, "catalogue");
		final TaxonIdentifier taxonIdentifier = new TaxonIdentifier();
		final String catalogueAbbr = catalogue.getEntity().getLabel().getAbbr();
		if (catalogueAbbr != null && catalogueAbbr.length() != 0)
			taxonIdentifier.getLabel().setAbbr(catalogueAbbr + " " + identifier);
		else
			taxonIdentifier.getLabel().setAbbr(null);
		taxonIdentifier.setAuthority(catalogue);
		taxonIdentifier.setEntity(new Taxon());
		taxonIdentifier.getEntity().setDefinition(new SpecimenDefinition());
		taxonIdentifier.setLocalName(URIUtil.escape(identifier));
		taxonIdentifier.getLabel().setName(catalogue.getEntity().getLabel().getName() + " " + identifier);
		// session.merge(taxonIdentifier.getEntity());
		session.save(taxonIdentifier);
		commitRequired = true;
		return taxonIdentifier;
	}
	public final Command<AuthorityIdentifier> getCatalogueCommand()
	{
		return catalogueCommand;
	}
	public final String getIdentifier()
	{
		return identifier;
	}
	public boolean readOnly()
	{
		return false;
	}
	public boolean requiresCommit()
	{
		return commitRequired || commandRequiresCommit(catalogueCommand);
	}
	public final void setCatalogueCommand(final Command<AuthorityIdentifier> catalogueCommand)
	{
		this.catalogueCommand = catalogueCommand;
	}
	public final void setIdentifier(final String identifier)
	{
		this.identifier = identifier == null ? null : identifier.trim().replaceAll("[^A-Za-z0-9'\\-]", "-").replaceAll(
		        "-+", "-");
	}
}
