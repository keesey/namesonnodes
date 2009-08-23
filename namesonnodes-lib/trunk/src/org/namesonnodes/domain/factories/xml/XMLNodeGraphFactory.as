package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.domain.*;
	import org.namesonnodes.domain.nodes.NodeGraph;

	public final class XMLNodeGraphFactory implements IFactory
	{
		private var entityFactory:EntityFactory;
		public function XMLNodeGraphFactory(source:XML = null)
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
		public function createNodeGraph(source:XML = null):NodeGraph
		{
			const entities:Vector.<Persistent> = entityFactory.createEntities(source);
			return new NodeGraph(entities);
		}
		public function newInstance():*
		{
			return entityFactory.newInstance();
		}
	}
}