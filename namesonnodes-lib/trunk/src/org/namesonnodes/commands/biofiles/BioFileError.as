package org.namesonnodes.commands.biofiles
{
	public final class BioFileError extends Error
	{
		public function BioFileError(message:*="", id:*=0)
		{
			super(message, id);
			this.name = "Bioinformatics File Error";
		}
	}
}