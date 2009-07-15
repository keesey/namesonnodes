package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.FindEquivalentTaxa")]
	public final class FindEquivalentTaxa implements Command
	{
		public var entityCommand:Command;
		public function FindEquivalentTaxa(entityCommand:Command = null)
		{
			super();
			this.entityCommand = entityCommand;
		}
	}
}