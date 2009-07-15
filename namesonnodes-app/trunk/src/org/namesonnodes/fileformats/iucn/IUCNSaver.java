package org.namesonnodes.fileformats.iucn;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.util.Set;
import javax.xml.parsers.ParserConfigurationException;
import org.hibernate.Session;
import org.namesonnodes.commands.Command;
import org.namesonnodes.commands.CommandException;
import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.fileformats.iucn.factories.ElementException;
import org.namesonnodes.fileformats.iucn.factories.ExportReader;
import org.namesonnodes.fileformats.iucn.model.Species;
import org.namesonnodes.fileformats.iucn.translators.RankCodesTranslator;
import org.namesonnodes.fileformats.iucn.translators.SpeciesTranslator;
import org.namesonnodes.fileformats.iucn.translators.TranslationException;
import org.namesonnodes.utils.DocumentUtil;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public final class IUCNSaver
{
	public void save(final Document document, final Session session) throws ElementException, TranslationException,
	        CommandException
	{
		final Set<Species> export = new ExportReader().read(document);
		final CommandList<Object> commandList = new CommandList<Object>();
		final SpeciesTranslator translator = new RankCodesTranslator();
		for (final Species species : export)
		{
			System.out.println("TRANSLATING SPECIES:\t" + species.scientificName);
			final Command<? extends Object> command = translator.translateToCommands(species);
			commandList.getCommands().add(command);
			System.out.println("COMMAND:\t" + command.toCommandString());
		}
		commandList.execute(session);
	}
	public void save(final InputStream inputStream, final Session session) throws CommandException, ElementException,
	        TranslationException, SAXException, IOException, ParserConfigurationException
	{
		final Document document = DocumentUtil.builderFactory.newDocumentBuilder().parse(inputStream);
		save(document, session);
	}
	public void save(final Reader reader, final Session session) throws SAXException, IOException,
	        ParserConfigurationException, ElementException, TranslationException, CommandException
	{
		final Document document = DocumentUtil.builderFactory.newDocumentBuilder().parse(new InputSource(reader));
		save(document, session);
	}
}
