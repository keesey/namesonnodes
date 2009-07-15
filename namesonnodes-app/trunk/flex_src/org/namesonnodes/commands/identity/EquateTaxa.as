package org.namesonnodes.commands.identity
{
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.entities.Taxon;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.identity.EquateSignifiers")]
	public final class EquateTaxa extends Equate
	{
		public function EquateTaxa()
		{
			super(TaxonIdentifier);
		}
	}
}