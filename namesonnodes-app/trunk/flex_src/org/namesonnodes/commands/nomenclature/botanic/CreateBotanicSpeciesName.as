package org.namesonnodes.commands.nomenclature.botanic
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias = "org.namesonnodes.commands.nomenclature.botanic.CreateBotanicSpeciesName")]
	public final class CreateBotanicSpeciesName implements Command
	{
		public var name:String;
		public var taxonCommand:Command;
		public var typesCommand:Command;
		public function CreateBotanicSpeciesName(name:String = null, typesCommand:Command = null, taxonCommand:Command = null)
		{
			super();
			this.name = name;
			this.typesCommand = typesCommand;
			this.taxonCommand = taxonCommand;
		}
	}
}