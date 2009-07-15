package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.FindEquivalentAuthorities")]
	public final class FindEquivalentAuthorities implements Command
	{
		public var entityCommand:Command;
		public function FindEquivalentAuthorities(entityCommand:Command = null)
		{
			super();
			this.entityCommand = entityCommand;
		}
	}
}