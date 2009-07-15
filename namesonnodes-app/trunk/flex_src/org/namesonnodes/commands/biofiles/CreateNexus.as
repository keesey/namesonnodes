package org.namesonnodes.commands.biofiles
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.biofiles.CreateNexus")]
	public final class CreateNexus extends EventDispatcher implements Command
	{
		public var abbr:String;
		public var data:ByteArray;
		public var name:String;
		public var weightPerGeneration:Number = 0;
		public var weightPerYear:Number = 0;
		public function CreateNexus()
		{
			super();
		}
	}
}