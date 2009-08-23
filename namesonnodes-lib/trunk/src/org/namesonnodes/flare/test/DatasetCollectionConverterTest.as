package org.namesonnodes.flare.test
{
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flare.flex.FlareVis;
	import flare.vis.controls.DragControl;
	import flare.vis.data.Data;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.layout.Layout;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.factories.xml.DatasetCollectionFactory;
	import org.namesonnodes.flare.DatasetCollectionConverter;
	
	public class DatasetCollectionConverterTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		private static var ENTITIES:Class;
		private var context:DatasetCollection;
		public function DatasetCollectionConverterTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createEntities():DatasetCollection
		{
			const bytes:ByteArray = new ENTITIES() as ByteArray;
			const source:XML = new XML(bytes.readUTFBytes(bytes.length));
			return new DatasetCollectionFactory(source).createDatasetCollection();
		}
		override public function setUp():void
		{
			super.setUp();
			context = createEntities();
		}
		override public function tearDown():void
		{
			super.tearDown();
			context = null;
		}
		public function testData():void
		{
			const converter:DatasetCollectionConverter = new DatasetCollectionConverter(context);
			const data:Data = converter.data;
			const vis:FlareVis = new FlareVis(data);
			vis.visHeight = 768;
			vis.visWidth = 1024;
			vis.controls = [new DragControl()];
			const layout:Layout = new NodeLinkTreeLayout();
			layout.layoutBounds = new Rectangle(0, 0, 1024, 768);
			vis.operators = [layout, new Labeler("data.label")];
			vis.visualization.continuousUpdates = true;
			layout.operate();
			UITestUtil.createTestWindow(vis, "DatasetCollectionConverter", addAsync(onCloseWindow, int.MAX_VALUE));
		}
		private function onCloseWindow(event:Event):void
		{
			// Do nothing.
		}
	}
}