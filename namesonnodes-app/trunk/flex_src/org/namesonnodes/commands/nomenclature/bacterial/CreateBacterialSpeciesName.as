package org.namesonnodes.commands.nomenclature.bacterial
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias = "org.namesonnodes.commands.nomenclature.bacterial.CreateBacterialSpeciesName")]
	public final class CreateBacterialSpeciesName implements Command
	{
		public var name:String;
		public var taxonCommand:Command;
		public var typesCommand:Command;
		public function CreateBacterialSpeciesName(name:String = null, typesCommand:Command = null, taxonCommand:Command = null)
		{
			super();
			this.name = name;
			this.typesCommand = typesCommand;
			this.taxonCommand = taxonCommand;
		}
	}
}