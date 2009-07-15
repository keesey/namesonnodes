package org.namesonnodes.commands.search
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias = "org.namesonnodes.commands.search.EpithetSearch")]
	public final class EpithetSearch implements Command
	{
		public var authorityCommand:Command;
		public var epithet:String;
		public function EpithetSearch(epithet:String = null, authorityCommand:Command = null)
		{
			super();
			this.epithet = epithet;
			this.authorityCommand = authorityCommand;
		}
	}
}