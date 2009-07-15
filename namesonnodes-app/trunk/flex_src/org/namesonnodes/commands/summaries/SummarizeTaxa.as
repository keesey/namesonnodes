package org.namesonnodes.commands.summaries
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.summaries.SummarizeTaxa")]
	public final class SummarizeTaxa extends EventDispatcher implements Command
	{
		public var entitiesCommand:Command;
		public function SummarizeTaxa(entitiesCommand:Command = null)
		{
			super();
			this.entitiesCommand = entitiesCommand;
		}
	}
}