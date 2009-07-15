package org.namesonnodes.commands.search
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias = "org.namesonnodes.commands.search.AuthorityLabelSearch")]
	public final class AuthorityLabelSearch implements Command
	{
		public var label:String;
		public function AuthorityLabelSearch()
		{
			super();
		}
	}
}