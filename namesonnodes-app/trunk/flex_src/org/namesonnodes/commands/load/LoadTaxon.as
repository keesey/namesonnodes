package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadTaxon")]
	public final class LoadTaxon extends AbstractLoad
	{
		public function LoadTaxon(id:uint=0)
		{
			super(id);
		}
	}
}