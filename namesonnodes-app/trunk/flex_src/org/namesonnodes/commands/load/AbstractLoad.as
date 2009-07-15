package org.namesonnodes.commands.load
{
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	internal class AbstractLoad implements Command
	{
		public var id:uint;
		public function AbstractLoad(id:uint = 0)
		{
			super();
			this.id = id;
		}
	}
}