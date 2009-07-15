package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.FindAllEquivalentTaxa")]
	public final class FindAllEquivalentTaxa implements Command
	{
		public var entitiesCommand:Command;
		public function FindAllEquivalentTaxa(entitiesCommand:Command = null)
		{
			super();
			this.entitiesCommand = entitiesCommand;
		}
	}
}