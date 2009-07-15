package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.EquateHomonyms")]
	public final class EquateHomonyms implements Command
	{
		public var authoritiesCommand:Command;
		public function EquateHomonyms()
		{
			super();
		}
	}
}