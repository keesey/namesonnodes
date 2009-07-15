package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.DifferentiateTaxa")]
	public final class DifferentiateTaxa implements Command
	{
		public var canonicalCommand:Command;
		public var identifiersCommand:Command;
		public function DifferentiateTaxa()
		{
			super();
		}
	}
}