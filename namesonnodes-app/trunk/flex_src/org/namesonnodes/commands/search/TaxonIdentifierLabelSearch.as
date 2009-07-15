package org.namesonnodes.commands.search
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias = "org.namesonnodes.commands.search.TaxonIdentifierLabelSearch")]
	public final class TaxonIdentifierLabelSearch implements Command
	{
		public var label:String;
		public function TaxonIdentifierLabelSearch()
		{
			super();
		}
	}
}