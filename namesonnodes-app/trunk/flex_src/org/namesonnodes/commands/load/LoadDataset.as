package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadDataset")]
	public final class LoadDataset extends AbstractLoad
	{
		public function LoadDataset(id:uint=0)
		{
			super(id);
		}
	}
}