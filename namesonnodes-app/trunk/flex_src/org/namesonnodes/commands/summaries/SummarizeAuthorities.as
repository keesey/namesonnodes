package org.namesonnodes.commands.summaries
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.summaries.SummarizeAuthorities")]
	public final class SummarizeAuthorities extends EventDispatcher implements Command
	{
		public var entitiesCommand:Command;
		public function SummarizeAuthorities(entitiesCommand:Command = null)
		{
			super();
			this.entitiesCommand = entitiesCommand;
		}
	}
}