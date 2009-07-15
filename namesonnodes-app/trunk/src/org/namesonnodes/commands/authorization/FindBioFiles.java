package org.namesonnodes.commands.authorization;

import org.namesonnodes.commands.Command;
import org.namesonnodes.domain.entities.AuthorityIdentifier;
import org.namesonnodes.domain.files.BioFile;

public final class FindBioFiles extends FindAuthorized<BioFile>
{
	private static final long serialVersionUID = 1104215782361110872L;
	public FindBioFiles()
	{
		super(BioFile.class);
	}
	public FindBioFiles(final Command<AuthorityIdentifier> authorityCommand)
	{
		super(BioFile.class, authorityCommand);
	}
}
