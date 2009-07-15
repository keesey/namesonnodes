package org.namesonnodes.commands.summaries
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.summaries.SummarizeTaxonIdentifiers")]
	public final class SummarizeTaxonIdentifiers extends EventDispatcher implements Command
	{
		public var entitiesCommand:Command;
		public function SummarizeTaxonIdentifiers(entitiesCommand:Command = null)
		{
			super();
			this.entitiesCommand = entitiesCommand;
		}
	}
}