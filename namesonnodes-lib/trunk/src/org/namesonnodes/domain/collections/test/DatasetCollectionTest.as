package org.namesonnodes.domain.collections.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.factories.xml.EntityFactory;

	public class DatasetCollectionTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		public static var source:Class;
		private var entities:Vector.<Persistent>;
		public function DatasetCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createEntities():Vector.<Persistent>
		{
			const bytes:ByteArray = new source() as ByteArray;
			const xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			const factory:EntityFactory = new EntityFactory(xml);
			return factory.readEntities();
		}
		override public function setUp() : void
		{
			super.setUp();
			entities = createEntities();
		}
		override public function tearDown() : void
		{
			super.tearDown();
			entities = null;
		}
		public function testDatasetCollection():void
		{
			new DatasetCollection(entities);
		}
		public function testDatasetDistance():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:Node = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Pan").singleMember as Node; 
			assertNotNull(Pan);
			const datasetQName:String = "org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::datasets:distances";
			assertEquals(0, collection.datasetDistance(datasetQName, Homo, Homo));
			assertEquals(0, collection.datasetDistance(datasetQName, Pan, Pan));
			assertEquals(80, collection.datasetDistance(datasetQName, Homo, Pan));
			assertEquals(80, collection.datasetDistance(datasetQName, Pan, Homo));
		}
		
		public function testGenerationDistance():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:Node = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Pan").singleMember as Node; 
			assertNotNull(Pan);
			assertEquals(0, collection.generationDistance(Homo, Homo));
			assertEquals(0, collection.generationDistance(Pan, Pan));
			assertEquals(550000 + 300000, collection.generationDistance(Homo, Pan));
			assertEquals(550000 + 300000, collection.generationDistance(Pan, Homo));
		}
		
		public function testImmediatePredecessors():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:FiniteSet = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Homo"); 
			assertEquals(1, Homo.size);
			const prc:FiniteSet = collection.immediatePredecessors(Homo.singleMember as Node);
			trace("Predecessors: " + prc);
		}
		
		public function testImmediateSuccessors():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const anc:FiniteSet = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::htu:0"); 
			assertEquals(1, anc.size);
			const suc:FiniteSet = collection.immediateSuccessors(anc.singleMember as Node);
			assertFalse(anc.empty);
			trace("Successors: " + suc);
		}
		public function testInterpretQName():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:FiniteSet = collection.interpretQName("org.namesonnodes.domain.factories.xml.test.EntityFactoryTest::otu:Homo"); 
			assertNotNull(Homo);
			assertEquals(Homo.size, 1);
			assertEquals(Node(Homo.singleMember).identifiers.size, 1);
			assertEquals(TaxonIdentifier(Node(Homo.singleMember).identifiers.singleMember).label.name, "Carolus Linnaeus");
		}
	}
}