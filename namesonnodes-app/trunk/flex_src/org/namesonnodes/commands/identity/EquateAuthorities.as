package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.EquateAuthorities")]
	public final class EquateAuthorities implements Command
	{
		public var entityCommand:Command;
		public var oldEntitiesCommand:Command;
		public function EquateAuthorities()
		{
			super();
		}
	}
}