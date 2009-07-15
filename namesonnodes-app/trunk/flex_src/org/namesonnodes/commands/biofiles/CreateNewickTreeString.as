package org.namesonnodes.commands.biofiles
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.biofiles.CreateNewickTreeString")]
	public final class CreateNewickTreeString extends EventDispatcher implements Command
	{
		public var abbr:String;
		public var name:String;
		public var treeString:String;
		public var weightPerGeneration:Number = 0;
		public var weightPerYear:Number = 0;
		public function CreateNewickTreeString()
		{
			super();
		}
	}
}