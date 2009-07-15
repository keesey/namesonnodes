package org.namesonnodes.commands.search
{
	import org.namesonnodes.commands.Command;
	
	[RemoteClass(alias="org.namesonnodes.commands.search.AuthoritySearch")]
	public final class AuthoritySearch implements Command
	{
		private var _text:String;
		private var _maxResults:uint;
		public function AuthoritySearch(text:String = "", maxResults:uint = 16)
		{
			super();
			_text = text;
			_maxResults = maxResults;
		}
		public function get maxResults():uint
		{
			return _maxResults;
		}
		public function set maxResults(v:uint):void
		{
			_maxResults = v;
		}
		public function get text():String
		{
			return _text;
		}
		public function set text(v:String):void
		{
			_text = v;
		}
	}
}