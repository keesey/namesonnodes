package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadAuthorityIdentifier")]
	public final class LoadAuthorityIdentifier extends AbstractLoad
	{
		public function LoadAuthorityIdentifier(id:uint=0)
		{
			super(id);
		}
	}
}