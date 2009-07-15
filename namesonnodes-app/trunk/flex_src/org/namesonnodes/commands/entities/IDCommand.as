package org.namesonnodes.commands.entities
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.entities.IDCommand")]
	public final class IDCommand extends EventDispatcher implements Command
	{
		public var command:Command;
		public function IDCommand()
		{
			super();
		}
	}
}