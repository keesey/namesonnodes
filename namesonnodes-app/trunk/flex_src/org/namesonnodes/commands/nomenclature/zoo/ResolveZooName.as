package org.namesonnodes.commands.nomenclature.zoo
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias="org.namesonnodes.commands.nomenclature.zoo.ResolveZooName")]
	public final class ResolveZooName implements Command
	{
		public var name:String;
		public function ResolveZooName(name:String = "")
		{
			super();
			this.name = name;
		}
	}
}