package org.namesonnodes.commands.summaries
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.core.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.summaries.SummarizeDatasets")]
	public final class SummarizeDatasets extends EventDispatcher implements Command
	{
		public var entitiesCommand:Command;
		public function SummarizeDatasets()
		{
			super();
		}
	}
}