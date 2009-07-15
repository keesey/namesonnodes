package org.namesonnodes.commands.resolve
{
	import org.namesonnodes.commands.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.resolve.ResolveURI")]
	public final class ResolveURI implements Command
	{
		public var uri:String;
		public function ResolveURI(uri:String = null)
		{
			super();
			this.uri = uri;
		}
	}
}