package org.namesonnodes.domain.collections.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.factories.xml.EntityFactory;

	public class DatasetCollectionTest extends TestCase
	{
		[Embed(source="../factories/xml/entities.xml",mimeType="application/octet-stream")]
		public static var source:Class;
		private static const datasets:Vector.<Dataset> = createDatasets();
		public function DatasetCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createDatasets():Vector.<Dataset>
		{
			const datasets:Vector.<Dataset> = new Vector.<Dataset>();
			const entities:Vector.<Persistent> = new EntityFactory(readXMLBytes(new source() as ByteArray)).readEntities();
			for each (var entity:Persistent in entities)
				if (entity is Dataset)
					datasets.push(entity as Dataset);
			return datasets;
		}
		public function DatasetCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testDatasetCollection():void
		{
			new DatasetCollection(datasets);
		}
		public function testDatasetDistance():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testGenerationDistance():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testImmediatePredecessors():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testImmediateSuccessors():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testInterpretQName():void
		{
			const collection:DatasetCollection = new DatasetCollection(datasets);
			const Homo:FiniteSet = collection.interpretQName("urn:isbn:0853010064::Homo"); 
			assertNotNull(Homo);
			assertEquals(Homo.size, 1);
			assertEquals(Node(Homo.singleMember).identifiers.size, 1);
			assertEquals(TaxonIdentifier(Node(Homo.singleMember).identifiers.singleMember).label.name, "Homo sapiens");
		}
	}
}