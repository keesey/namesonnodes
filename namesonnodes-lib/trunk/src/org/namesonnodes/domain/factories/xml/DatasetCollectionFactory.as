package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.domain.collections.DatasetCollection;

	public final class DatasetCollectionFactory implements IFactory
	{
		private var entityFactory:EntityFactory;
		public function DatasetCollectionFactory(source:XML = null)
		{
			super();
			entityFactory = new EntityFactory(source);
		}
		public function get source():XML
		{
			return entityFactory.source;
		}
		public function set source(v:XML):void
		{
			entityFactory.source = v;
		}
		public function createDatasetCollection(source:XML = null):DatasetCollection
		{
			const entities:Vector.<Persistent> = entityFactory.createEntities(source);
			return new DatasetCollection(entities);
		}
		public function newInstance():*
		{
			return entityFactory.newInstance();
		}
	}
}