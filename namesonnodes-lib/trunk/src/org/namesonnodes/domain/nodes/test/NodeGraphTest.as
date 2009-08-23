package org.namesonnodes.domain.nodes.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.factories.xml.EntityFactory;
	import org.namesonnodes.domain.nodes.Node;
	import org.namesonnodes.domain.nodes.NodeGraph;

	public class NodeGraphTest extends TestCase
	{
		[Embed(source="entities1.xml",mimeType="application/octet-stream")]
		public static var source1:Class;
		[Embed(source="entities2.xml",mimeType="application/octet-stream")]
		public static var source2:Class;
		private var entities1:Vector.<Persistent>;
		private var entities2:Vector.<Persistent>;
		public function NodeGraphTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createEntities():Vector.<Persistent>
		{
			const bytes:ByteArray = new source1() as ByteArray;
			const xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			const factory:EntityFactory = new EntityFactory(xml);
			return factory.createEntities();
		}
		private static function createEntities2():Vector.<Persistent>
		{
			const bytes:ByteArray = new source2() as ByteArray;
			const xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			const factory:EntityFactory = new EntityFactory(xml);
			return factory.createEntities();
		}
		override public function setUp() : void
		{
			super.setUp();
			entities1 = createEntities();
			entities2 = createEntities2();
		}
		override public function tearDown() : void
		{
			super.tearDown();
			entities1 = null;
			entities2 = null;
		}
		public function testNodeGraph():void
		{
			new NodeGraph(entities1);
		}
		public function testDatasetDistance():void
		{
			const graph:NodeGraph = new NodeGraph(entities1);
			const Homo:Node = graph.interpretQName("urn:isbn:0853010064::Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = graph.interpretQName("urn:isbn:0853010064::Pan").singleMember as Node; 
			assertNotNull(Pan);
			const datasetQName:String = "org.namesonnodes.domain.nodes.test.NodeGraphTest::datasets:distances";
			assertEquals(0, graph.datasetDistance(datasetQName, Homo, Homo));
			assertEquals(0, graph.datasetDistance(datasetQName, Pan, Pan));
			assertEquals(80, graph.datasetDistance(datasetQName, Homo, Pan));
			assertEquals(80, graph.datasetDistance(datasetQName, Pan, Homo));
		}
		
		public function testGenerationDistance():void
		{
			const graph:NodeGraph = new NodeGraph(entities1);
			const Homo:Node = graph.interpretQName("urn:isbn:0853010064::Homo").singleMember as Node; 
			assertNotNull(Homo);
			const Pan:Node = graph.interpretQName("urn:isbn:0853010064::Pan").singleMember as Node; 
			assertNotNull(Pan);
			assertEquals(0, graph.generationDistance(Homo, Homo));
			assertEquals(0, graph.generationDistance(Pan, Pan));
			assertEquals(550000 + 300000, graph.generationDistance(Homo, Pan));
			assertEquals(550000 + 300000, graph.generationDistance(Pan, Homo));
		}
		public function testImmediatePredecessors():void
		{
			const graph:NodeGraph = new NodeGraph(entities1);
			const Homo:FiniteSet = graph.interpretQName("urn:isbn:0853010064::Homo");
			assertEquals(1, Homo.size);
			const prc:FiniteSet = graph.immediatePredecessors(Homo.singleMember as Node);
		}
		public function testImmediatePredecessors2():void
		{
			const graph:NodeGraph = new NodeGraph(entities2);
			const Homo:FiniteSet = graph.interpretQName("urn:isbn:0853010064::Homo");
			assertEquals(1, Homo.size);
			const prc:FiniteSet = graph.immediatePredecessors(Homo.singleMember as Node);
			trace("Predecessors: " + prc);
		}
		public function testImmediateSuccessors():void
		{
			const graph:NodeGraph = new NodeGraph(entities1);
			const anc:FiniteSet = graph.interpretQName("org.namesonnodes.domain.nodes.test.NodeGraphTest::htu:0"); 
			assertEquals(1, anc.size);
			const suc:FiniteSet = graph.immediateSuccessors(anc.singleMember as Node);
			assertFalse(anc.empty);
		}
		public function testInterpretQName():void
		{
			const graph:NodeGraph = new NodeGraph(entities1);
			const Homo:FiniteSet = graph.interpretQName("urn:isbn:0853010064::Homo");
			assertNotNull(Homo);
			assertEquals(Homo.size, 1);
			assertEquals(Node(Homo.singleMember).identifiers.size, 1);
			assertEquals(TaxonIdentifier(Node(Homo.singleMember).identifiers.singleMember).label.name, "Carolus Linnaeus");
		}
	}
}