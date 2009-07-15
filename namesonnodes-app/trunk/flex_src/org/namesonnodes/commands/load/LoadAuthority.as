package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadAuthority")]
	public final class LoadAuthority extends AbstractLoad
	{
		public function LoadAuthority(id:uint=0)
		{
			super(id);
		}
	}
}