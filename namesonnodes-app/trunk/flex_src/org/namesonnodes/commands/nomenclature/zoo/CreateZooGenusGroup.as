package org.namesonnodes.commands.nomenclature.zoo
{
	import flash.events.IEventDispatcher;
	import org.namesonnodes.commands.Command;
	import flash.events.EventDispatcher;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.nomenclature.zoo.CreateZooGenusGroup")]
	public final class CreateZooGenusGroup extends EventDispatcher implements Command
	{
		public var baseName:String;
		public var typeCommand:Command;
		public var taxonCommand:Command;
		public function CreateZooGenusGroup(baseName:String = null, typeCommand:Command = null, taxonCommand:Command = null)
		{
			super();
			this.baseName = baseName;
			this.typeCommand = typeCommand;
			this.taxonCommand = taxonCommand;
		}
	}
}