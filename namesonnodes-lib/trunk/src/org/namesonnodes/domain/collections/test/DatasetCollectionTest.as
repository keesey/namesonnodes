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
		[Embed(source="entities2.xml",mimeType="application/octet-stream")]
		public static var source2:Class;
		private var entities:Vector.<Persistent>;
		private var entities2:Vector.<Persistent>;
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
		private static function createEntities2():Vector.<Persistent>
		{
			const bytes:ByteArray = new source2() as ByteArray;
			const xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			const factory:EntityFactory = new EntityFactory(xml);
			return factory.readEntities();
		}
		override public function setUp() : void
		{
			super.setUp();
			entities = createEntities();
			entities2 = createEntities2();
		}
		override public function tearDown() : void
		{
			super.tearDown();
			entities = null;
			entities2 = null;
		}
		public function testDatasetCollection():void
		{
			new DatasetCollection(entities);
		}
		public function testDatasetDistance():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:Node = collection.interpretQName("urn:isbn:0853010064::Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = collection.interpretQName("urn:isbn:0853010064::Pan").singleMember as Node; 
			assertNotNull(Pan);
			const datasetQName:String = "org.namesonnodes.domain.collections.test.DatasetCollectionTest::datasets:distances";
			assertEquals(0, collection.datasetDistance(datasetQName, Homo, Homo));
			assertEquals(0, collection.datasetDistance(datasetQName, Pan, Pan));
			assertEquals(80, collection.datasetDistance(datasetQName, Homo, Pan));
			assertEquals(80, collection.datasetDistance(datasetQName, Pan, Homo));
		}
		
		public function testGenerationDistance():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:Node = collection.interpretQName("urn:isbn:0853010064::Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = collection.interpretQName("urn:isbn:0853010064::Pan").singleMember as Node; 
			assertNotNull(Pan);
			assertEquals(0, collection.generationDistance(Homo, Homo));
			assertEquals(0, collection.generationDistance(Pan, Pan));
			assertEquals(550000 + 300000, collection.generationDistance(Homo, Pan));
			assertEquals(550000 + 300000, collection.generationDistance(Pan, Homo));
		}
		public function testImmediatePredecessors():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:FiniteSet = collection.interpretQName("urn:isbn:0853010064::Homo");
			assertEquals(1, Homo.size);
			const prc:FiniteSet = collection.immediatePredecessors(Homo.singleMember as Node);
		}
		public function testImmediatePredecessors2():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities2);
			const Homo:FiniteSet = collection.interpretQName("urn:isbn:0853010064::Homo");
			assertEquals(1, Homo.size);
			const prc:FiniteSet = collection.immediatePredecessors(Homo.singleMember as Node);
			trace("Predecessors: " + prc);
		}
		public function testImmediateSuccessors():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const anc:FiniteSet = collection.interpretQName("org.namesonnodes.domain.collections.test.DatasetCollectionTest::htu:0"); 
			assertEquals(1, anc.size);
			const suc:FiniteSet = collection.immediateSuccessors(anc.singleMember as Node);
			assertFalse(anc.empty);
		}
		public function testInterpretQName():void
		{
			const collection:DatasetCollection = new DatasetCollection(entities);
			const Homo:FiniteSet = collection.interpretQName("urn:isbn:0853010064::Homo");
			assertNotNull(Homo);
			assertEquals(Homo.size, 1);
			assertEquals(Node(Homo.singleMember).identifiers.size, 1);
			assertEquals(TaxonIdentifier(Node(Homo.singleMember).identifiers.singleMember).label.name, "Carolus Linnaeus");
		}
	}
}