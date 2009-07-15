package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadRankDefinition")]
	public final class LoadRankDefinition extends AbstractLoad
	{
		public function LoadRankDefinition(id:uint=0)
		{
			super(id);
		}
	}
}