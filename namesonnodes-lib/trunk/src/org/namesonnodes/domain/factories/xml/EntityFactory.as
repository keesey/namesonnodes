package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.domain.entities.Entities;

	public final class EntityFactory extends EventDispatcher implements IFactory
	{
		internal const dictionary:Dictionary = new Dictionary();
		private const readers:Dictionary = new Dictionary();
		internal const authorityReferences:Vector.<AuthorityReference> = new Vector.<AuthorityReference>();
		internal const taxonReferences:Vector.<TaxonReference> = new Vector.<TaxonReference>();
		[Bindable]
		public var source:XML;
		public function EntityFactory(source:XML = null)
		{
			super();
			initReaders();
			this.source = source;
		}
		private function initReaders():void
		{
			const authorityIdentifierReader:EntityReader = new AuthorityIdentifierReader(this);
			const taxonIdentifierReader:EntityReader = new TaxonIdentifierReader(this, authorityIdentifierReader);
			readers["AuthorityIdentifier"] = authorityIdentifierReader;
			readers["Dataset"] = new DatasetReader(this, authorityIdentifierReader, taxonIdentifierReader);
			readers["TaxonIdentifier"] = taxonIdentifierReader;
		}
		public function newInstance():*
		{
			return readEntities();
		}
		protected function readEntity(source:XML):Persistent
		{
			if (source == null || source.name() == null)
				return null;
			if (QName(source.name()).uri != Entities.URI)
				throw new ArgumentError("Unrecognized namespace: <" + QName(source.name()).uri + ">.");
			const reader:EntityReader = readers[source.localName()] as EntityReader;
			if (reader == null)
				throw new ArgumentError("Unrecognized node name: <" + source.name() + ">.");
			return reader.readEntity(source);
		}
		public function readEntities(source:XML = null):Vector.<Persistent>
		{
			if (source != null)
				this.source = source;
			if (this.source == null)
				return null;
			const entities:Vector.<Persistent> = new Vector.<Persistent>(this.source.children().length());
			for each (var entitySource:XML in this.source.children())
				entities.push(readEntity(entitySource));
			while (authorityReferences.length != 0)
				authorityReferences.pop().useDictionary(dictionary);
			while (taxonReferences.length != 0)
				taxonReferences.pop().useDictionary(dictionary);
			return entities;
		}
	}
}
