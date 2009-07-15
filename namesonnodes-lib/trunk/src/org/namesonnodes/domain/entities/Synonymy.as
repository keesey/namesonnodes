package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Synonymy")]
	public final class Synonymy extends AbstractPersistent
	{
		private const _synonyms:ArrayCollection = createEntityCollection(TaxonIdentifier);
		public function Synonymy()
		{
			super();
		}
		public function get synonyms():ArrayCollection
		{
			return _synonyms;
		}
		public function set synonyms(value:ArrayCollection):void
		{
			_synonyms.source = value ? value.source : [];
			_synonyms.refresh();
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span/>;
			for (var i:uint = 0; i < _synonyms.length; ++i)
			{
				if (i > 0)
					xml.appendChild(" = ");
				xml.appendChild(TaxonIdentifier(_synonyms.getItemAt(i)).toSummaryHTML());
			}
			return xml.normalize();
		}
	}
}