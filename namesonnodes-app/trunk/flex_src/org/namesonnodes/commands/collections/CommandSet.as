package org.namesonnodes.commands.collections
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import mx.collections.ArrayCollection;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.collections.CommandSet")]
	public final class CommandSet implements Command
	{
		private const _commands:ArrayCollection = new ArrayCollection();
		private const _commandSet:MutableSet = new HashSet();
		public function CommandSet(source:Object = null)
		{
			super();
			for each (var command:Object in source)
				if (command is Command)
					_commandSet.add(command);
			_commands.source = _commandSet.toArray();
		}
		public function get commands():ArrayCollection
		{
			return _commands;
		}
		public function set commands(value:ArrayCollection):void
		{
			_commandSet.clear();
			_commandSet.addMembers(value);
			_commands.source = _commandSet.toArray();
			_commands.refresh();
		}
	}
}