package org.namesonnodes.commands.identity
{
	import org.namesonnodes.commands.core.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.ExtractTaxon")]
	public final class ExtractTaxon implements Command
	{
		public var identityCommand:Command;
		public function ExtractTaxon()
		{
			super();
		}
	}
}