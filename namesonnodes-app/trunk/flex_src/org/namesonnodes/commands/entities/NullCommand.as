package org.namesonnodes.commands.entities
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.entities.NullCommand")]
	public final class NullCommand extends EventDispatcher implements Command
	{
		public var command:Command;
		public function NullCommand(command:Command = null)
		{
			super();
			this.command = command;
		}
	}
}