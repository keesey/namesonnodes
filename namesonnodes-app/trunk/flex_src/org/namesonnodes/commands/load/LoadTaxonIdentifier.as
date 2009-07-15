package org.namesonnodes.commands.load
{
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.load.LoadTaxonIdentifier")]
	public final class LoadTaxonIdentifier extends AbstractLoad
	{
		public function LoadTaxonIdentifier(id:uint=0)
		{
			super(id);
		}
	}
}