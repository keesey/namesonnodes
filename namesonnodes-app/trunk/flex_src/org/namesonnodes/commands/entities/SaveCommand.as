package org.namesonnodes.commands.entities
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.entities.SaveCommand")]
	public final class SaveCommand extends EventDispatcher implements Command
	{
		public var command:Command;
		public function SaveCommand()
		{
			super();
		}
	}
}