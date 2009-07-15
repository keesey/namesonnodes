package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.DifferentiateAuthorities")]
	public final class DifferentiateAuthorities implements Command
	{
		public var canonicalCommand:Command;
		public var identifiersCommand:Command;
		public function DifferentiateAuthorities()
		{
			super();
		}
	}
}