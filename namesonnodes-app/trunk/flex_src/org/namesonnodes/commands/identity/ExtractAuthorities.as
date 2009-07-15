package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.ExtractAuthorities")]
	public final class ExtractAuthorities implements Command
	{
		public var identifiersCommand:Command;
		public function ExtractAuthorities(identifiersCommand:Command = null)
		{
			super();
			this.identifiersCommand = identifiersCommand;
		}
	}
}