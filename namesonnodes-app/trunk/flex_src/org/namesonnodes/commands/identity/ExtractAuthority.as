package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.ExtractAuthority")]
	public final class ExtractAuthority implements Command
	{
		public var identityCommand:Command;
		public function ExtractAuthority()
		{
			super();
		}
	}
}