package org.namesonnodes.fileformats.iucn.translators;

import java.util.HashMap;
import java.util.Map;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.nomenclature.CreateVernacular;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public final class VernacularCommandTable
{
	private final Command<AuthorityIdentifier> authorityCommand;
	private final Map<String, Command<TaxonIdentifier>> localNameMap = new HashMap<String, Command<TaxonIdentifier>>();
	public VernacularCommandTable(final Command<AuthorityIdentifier> authorityCommand)
	{
		super();
		this.authorityCommand = authorityCommand;
	}
	public Command<TaxonIdentifier> getByLocalName(final String localName, final String name,
	        final Command<Taxon> identityCommand)
	{
		if (localNameMap.containsKey(localName))
			return localNameMap.get(localName);
		final CreateVernacular createVernacular = new CreateVernacular();
		createVernacular.setAuthorityCommand(authorityCommand);
		createVernacular.setEntityCommand(identityCommand);
		createVernacular.setLocalName(localName);
		createVernacular.setName(name);
		localNameMap.put(localName, createVernacular);
		return createVernacular;
	}
}
