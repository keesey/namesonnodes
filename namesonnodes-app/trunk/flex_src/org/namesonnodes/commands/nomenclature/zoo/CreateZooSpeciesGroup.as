package org.namesonnodes.commands.nomenclature.zoo
{
	import flash.events.EventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.nomenclature.zoo.CreateZooSpeciesGroup")]
	public final class CreateZooSpeciesGroup extends EventDispatcher implements Command
	{
		public var baseName:String;
		public var taxonCommand:Command;
		public var typeCommand:Command;
		public function CreateZooSpeciesGroup(baseName:String = null, typeCommand:Command = null, taxonCommand:Command = null)
		{
			super();
			this.baseName = baseName;
			this.typeCommand = typeCommand;
			this.taxonCommand = taxonCommand;
		}
	}
}