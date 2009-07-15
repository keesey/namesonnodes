package org.namesonnodes.fileformats.iucn.translators;

import org.namesonnodes.commands.collections.CommandList;
import org.namesonnodes.fileformats.iucn.model.Species;

public interface SpeciesTranslator
{
	public CommandList<?> translateToCommands(final Species species) throws TranslationException;
}