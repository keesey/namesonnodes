package org.namesonnodes.commands.specimens
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias="org.namesonnodes.commands.specimens.CreateSpecimen")]
	public final class CreateSpecimen extends EventDispatcher implements Command
	{
		public var catalogueCommand:Command;
		public var identifier:String;
		public function CreateSpecimen()
		{
			super();
		}
	}
}