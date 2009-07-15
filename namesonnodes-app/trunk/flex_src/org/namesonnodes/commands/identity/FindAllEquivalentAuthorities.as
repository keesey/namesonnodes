package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.FindAllEquivalentAuthorities")]
	public final class FindAllEquivalentAuthorities implements Command
	{
		public var entitiesCommand:Command;
		public function FindAllEquivalentAuthorities(entitiesCommand:Command = null)
		{
			super();
			this.entitiesCommand = entitiesCommand;
		}
	}
}