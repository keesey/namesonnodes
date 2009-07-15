package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadDefinition")]
	public final class LoadDefinition extends AbstractLoad
	{
		public function LoadDefinition(id:uint=0)
		{
			super(id);
		}
	}
}