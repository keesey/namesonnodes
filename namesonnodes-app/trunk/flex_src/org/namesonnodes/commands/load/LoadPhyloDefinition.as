package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadPhyloDefinition")]
	public final class LoadPhyloDefinition extends AbstractLoad
	{
		public function LoadPhyloDefinition(id:uint=0)
		{
			super(id);
		}
	}
}