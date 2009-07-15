package org.namesonnodes.commands.nomenclature.botanic;

import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getLevel;
import static org.namesonnodes.commands.nomenclature.botanic.BotanicalRank.getPattern;
import static org.namesonnodes.utils.URIUtil.escape;
import java.util.Set;
import org.hibernate.Session;
import org.namesonnodes.commands.AbstractCommand;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.entities.RankDefinition;
import org.namesonnodes.domain.entities.Taxon;
import org.namesonnodes.domain.entities.TaxonIdentifier;

public abstract class CreateBotanicName extends AbstractCommand<TaxonIdentifier>
{
	private static final long serialVersionUID = 3210414771908347786L;
	private final Command<AuthorityIdentifier> authorityCommand = new BotanicalCode();
	protected Command<Taxon> taxonCommand;
	protected boolean commitRequired;
	protected String name;
	@Override
	protected final TaxonIdentifier doExecute(final Session session) throws CommandException
	{
		if (name == null || name == "")
			throw new CommandException("No name provided.");
		if (!name.matches(getPattern(rankName())))
			throw new CommandException("Invalid botanical " + rankName() + " name: \"" + name + "\".");
		final TaxonIdentifier name = formulateName(session);
		if (commitRequired)
			session.save(name);
		return name;
	}
	private void checkExistingDefinition(final Taxon taxon, final Session session) throws CommandException
	{
		if (taxon.getDefinition() != null)
		{
			if (taxon.getDefinition() instanceof RankDefinition)
			{
				final RankDefinition rankDef = (RankDefinition) taxon.getDefinition();
				if (!rankDef.getTypes().equals(types(session)))
					throw new CommandException("\"" + name + "\" was already defined with different typification.");
				if (!rankDef.getRank().equals(rankName()))
					throw new CommandException("\"" + name + "\" was already defined with a different rank.");
				return;
			}
			throw new CommandException("Invalid definition in database for botanical name \"" + name + "\".");
		}
		throw new CommandException("No definition in database for botanical name \"" + name + "\".");
	}
	private TaxonIdentifier formulateName(final Session session) throws CommandException
	{
		final AuthorityIdentifier authority = acquire(authorityCommand, session, "botanical code");
		final String localName = escape(name);
		final String qName = authority.getUri() + "::" + localName;
		TaxonIdentifier taxonIdentifier = new ResolveTaxonIdentifier(qName).execute(session);
		if (taxonIdentifier != null)
		{
			final Taxon taxon = taxonIdentifier.getEntity();
			checkExistingDefinition(taxon, session);
		}
		else
		{
			taxonIdentifier = new TaxonIdentifier();
			taxonIdentifier.setAuthority(authority);
			if (taxonCommand == null)
			{
				taxonIdentifier.setEntity(new Taxon());
				final RankDefinition rankDefinition = new RankDefinition();
				rankDefinition.setLevel(getLevel(rankName()));
				rankDefinition.setRank(rankName());
				rankDefinition.setTypes(types(session));
				taxonIdentifier.getEntity().setDefinition(rankDefinition);
			}
			else
			{
				taxonIdentifier.setEntity(acquire(taxonCommand, session, "taxon"));
				checkExistingDefinition(taxonIdentifier.getEntity(), session);
			}
			taxonIdentifier.setLocalName(localName);
			taxonIdentifier.getLabel().setAbbr(getIdentifierAbbr());
			taxonIdentifier.getLabel().setItalics(true);
			taxonIdentifier.getLabel().setName(name);
		}
		commitRequired = true;
		return taxonIdentifier;
	}
	protected abstract String getIdentifierAbbr();
	public final String getName()
	{
		return name;
	}
	public Command<Taxon> getTaxonCommand()
	{
		return taxonCommand;
	}
	protected abstract String rankName();
	public final boolean readOnly()
	{
		return false;
	}
	public final boolean requiresCommit()
	{
		return commitRequired;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
	public void setTaxonCommand(Command<Taxon> taxonCommand)
	{
		this.taxonCommand = taxonCommand;
	}
	protected abstract Set<TaxonIdentifier> types(final Session session) throws CommandException;
}
