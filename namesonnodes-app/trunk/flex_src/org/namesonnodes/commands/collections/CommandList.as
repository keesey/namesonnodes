package org.namesonnodes.commands.collections
{
	import a3lbmonkeybrain.brainstem.filter.filterType;
	
	import mx.collections.ArrayCollection;
	
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.collections.CommandList")]
	public final class CommandList implements Command
	{
		private const _commands:ArrayCollection = new ArrayCollection();
		public function CommandList(source:Object = null)
		{
			super();
			_commands.filterFunction = filterType(Command);
			for each (var command:Object in source)
				_commands.addItem(command);
		}
		public function get commands():ArrayCollection
		{
			return _commands;
		}
		public function set commands(value:ArrayCollection):void
		{
			_commands.source = value ? value.source : [];
			_commands.refresh();
		}
	}
}