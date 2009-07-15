package org.namesonnodes.commands.search
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.search.TaxonSearch")]
	public final class TaxonSearch extends EventDispatcher implements Command
	{
		public var maxResults:uint;
		public var text:String;
		public function TaxonSearch(text:String = null, maxResults:uint = 16)
		{
			super();
			this.text = text;
			this.maxResults = maxResults;
		}
	}
}