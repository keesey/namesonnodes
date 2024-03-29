package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.w3c.xml.XMLNodeKind;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.domain.entities.Entities;

	public final class EntityFactory extends EventDispatcher implements IFactory
	{
		internal const dictionary:Dictionary = new Dictionary();
		private const readers:Dictionary = new Dictionary();
		internal const authorityReferences:Vector.<IdentifierReference> = new Vector.<IdentifierReference>();
		internal const taxonReferences:Vector.<IdentifierReference> = new Vector.<IdentifierReference>();
		[Bindable]
		public var source:XML;
		public function EntityFactory(source:XML = null)
		{
			super();
			initReaders();
			this.source = source;
		}
		public function createEntities(source:XML = null):Vector.<Persistent>
		{
			if (source != null)
				this.source = source;
			if (this.source == null)
				return null;
			const entities:Vector.<Persistent> = new Vector.<Persistent>(this.source.children().length());
			var i:uint = 0;
			for each (var entitySource:XML in this.source.children())
				if (entitySource.nodeKind() == XMLNodeKind.ELEMENT)
					entities[i++] = readEntity(entitySource);
			resolveReferences(authorityReferences);
			resolveReferences(taxonReferences);
			return entities;
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
			return createEntities();
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
		private function resolveReferences(refs:Vector.<IdentifierReference>):void
		{
			const l:uint = refs.length;
			if (l == 0)
				return;
			const remainingRefs:Vector.<IdentifierReference> = new Vector.<IdentifierReference>();
			for each (var ref:IdentifierReference in refs)
			{
				if (!ref.useDictionary(dictionary))
					remainingRefs.push(ref);
			}
			if (remainingRefs.length == l)
				throw new Error("Circular reference detected in entity data:\n\t" + refs.join("\n\t"));
			resolveReferences(remainingRefs);
		}
	}
}
