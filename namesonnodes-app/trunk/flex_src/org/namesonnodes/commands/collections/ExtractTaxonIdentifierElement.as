package org.namesonnodes.commands.collections
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias="org.namesonnodes.commands.collections.ExtractTaxonIdentifierElement")]
	public final class ExtractTaxonIdentifierElement extends EventDispatcher implements Command
	{
		public var index:uint;
		public var listCommand:Command;
		public function ExtractTaxonIdentifierElement(listCommand:Command = null, index:uint = 0)
		{
			super();
			this.index = index;
			this.listCommand = listCommand;
		}
	}
}