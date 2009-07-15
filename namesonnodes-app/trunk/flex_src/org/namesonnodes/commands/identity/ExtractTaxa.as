package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.ExtractTaxa")]
	public final class ExtractTaxa implements Command
	{
		public var identifiersCommand:Command;
		public function ExtractTaxa(identifiersCommand:Command = null)
		{
			super();
			this.identifiersCommand = identifiersCommand;
		}
	}
}