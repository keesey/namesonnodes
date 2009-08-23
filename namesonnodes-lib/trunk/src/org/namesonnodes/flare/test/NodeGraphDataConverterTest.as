package org.namesonnodes.flare.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flare.flex.FlareVis;
	import flare.vis.data.Data;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.factories.xml.XMLNodeGraphFactory;
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.flare.NodeGraphVis;
	import org.namesonnodes.flare.NodeGraphDataConverter;
	
	public class NodeGraphDataConverterTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		private static var ENTITIES:Class;
		private var nodeGraph:NodeGraph;
		public function NodeGraphDataConverterTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createNodeGraph():NodeGraph
		{
			const bytes:ByteArray = new ENTITIES() as ByteArray;
			const source:XML = new XML(bytes.readUTFBytes(bytes.length));
			return new XMLNodeGraphFactory(source).createNodeGraph();
		}
		override public function setUp():void
		{
			super.setUp();
			nodeGraph = createNodeGraph();
		}
		override public function tearDown():void
		{
			super.tearDown();
			nodeGraph = null;
		}
		public function testData():void
		{
			const converter:NodeGraphDataConverter = new NodeGraphDataConverter(nodeGraph);
			const data:Data = converter.data;
			const vis:FlareVis = new NodeGraphVis(data);
			vis.visHeight = 768;
			vis.visWidth = 1024;
			UITestUtil.createTestWindow(vis, "NodeGraphDataConverterTest", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}