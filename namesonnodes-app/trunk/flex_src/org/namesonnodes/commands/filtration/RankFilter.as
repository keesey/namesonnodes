package org.namesonnodes.commands.filtration
{
	import org.namesonnodes.commands.Command;

	[RemoteClass(alias = "org.namesonnodes.commands.filtration.RankFilter")]
	public final class RankFilter implements Command
	{
		public var rank:String;
		public var entitiesCommand:Command;
		public function RankFilter(rank:String = null, entitiesCommand:Command = null)
		{
			super();
			this.rank = rank;
			this.entitiesCommand = entitiesCommand;
		}
	}
}