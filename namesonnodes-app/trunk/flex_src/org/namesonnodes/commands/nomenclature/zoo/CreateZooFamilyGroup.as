package org.namesonnodes.commands.nomenclature.zoo
{
	import flash.events.IEventDispatcher;
	import org.namesonnodes.commands.Command;
	import flash.events.EventDispatcher;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.nomenclature.zoo.CreateZooFamilyGroup")]
	public final class CreateZooFamilyGroup extends EventDispatcher implements Command
	{
		public var baseName:String;
		public var typeCommand:Command;
		public var taxonCommand:Command;
		public function CreateZooFamilyGroup(baseName:String = null, typeCommand:Command = null, taxonCommand:Command = null)
		{
			super();
			this.baseName = baseName;
			this.typeCommand = typeCommand;
			this.taxonCommand = taxonCommand;
		}
	}
}