package org.namesonnodes.commands.specimens
{
	import flash.events.Event;
	
	import mx.utils.OnDemandEventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[RemoteClass(alias="org.namesonnodes.commands.specimens.CreateCatalogue")]
	public final class CreateCatalogue extends OnDemandEventDispatcher implements Command
	{
		private var _abbr:String;
		private var _name:String;
		private var _uri:String;
		public function CreateCatalogue()
		{
			super();
		}
		[Bindable(event = "abbrChanged")]
		public function get abbr():String
		{
			return _abbr;
		}
		public function set abbr(v:String):void
		{
			if (_abbr != v)
			{
				_abbr = v;
				dispatchEvent(new Event("abbrChanged"));
			}
		}
		[Bindable(event = "nameChanged")]
		public function get name():String
		{
			return _name;
		}
		public function set name(v:String):void
		{
			if (_name != v)
			{
				_name = v;
				dispatchEvent(new Event("nameChanged"));
			}
		}
		[Bindable(event = "uriChanged")]
		public function get uri():String
		{
			return _uri;
		}
		public function set uri(v:String):void
		{
			if (_uri != v)
			{
				_uri = v;
				dispatchEvent(new Event("uriChanged"));
			}
		}
	}
}