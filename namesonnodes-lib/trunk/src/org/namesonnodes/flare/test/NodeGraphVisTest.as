package org.namesonnodes.flare.test
{
	import a3lbmonkeybrain.brainstem.assert.assertType;
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flare.vis.data.Data;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import flexunit.framework.TestCase;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.biofiles.BioFileFormat;
	import org.namesonnodes.commands.biofiles.ParseResult;
	import org.namesonnodes.commands.biofiles.nexus.NexusFormat;
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.flare.NodeGraphDataConverter;
	import org.namesonnodes.flare.NodeGraphVis;
	
	public class NodeGraphVisTest extends TestCase
	{
		private var format:BioFileFormat;
		public function NodeGraphVisTest(methodName:String=null)
		{
			super(methodName);
		}
		override public function setUp():void
		{
			super.setUp();
			format = new NexusFormat();
		}
		override public function tearDown():void
		{
			super.tearDown();
			format = null;
		}
		public function testNodeGraphVis():void
		{
			const fileRef:FileReference = new FileReference();
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, trace);
			fileRef.addEventListener(Event.CANCEL, trace);
			fileRef.addEventListener(Event.COMPLETE, trace);
			fileRef.addEventListener(Event.OPEN, trace);
			fileRef.addEventListener(Event.SELECT, trace);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, trace);
			fileRef.addEventListener(ProgressEvent.PROGRESS, trace);
			fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, trace);
			fileRef.addEventListener(Event.SELECT, addAsync(onFileSelect, int.MAX_VALUE));
			fileRef.browse([format.filter, new FileFilter("All Files", "*")]);
		}
		private function onFileSelect(event:Event):void
		{
			const fileRef:FileReference = event.target as FileReference;
			fileRef.addEventListener(Event.COMPLETE, addAsync(onFileComplete, 60 * 1000));
			fileRef.load();
		}
		private function onFileComplete(event:Event):void
		{
			const fileRef:FileReference = event.target as FileReference;
			format.addEventListener(ResultEvent.RESULT, addAsync(onNexusResult, 60 * 1000));
			format.addEventListener(InvokeEvent.INVOKE, trace);
			format.addEventListener(FaultEvent.FAULT, trace);
			format.addEventListener(ProgressEvent.PROGRESS, trace);
			format.invoke(fileRef.data);
		}
		private function onNexusResult(event:ResultEvent):void
		{
			assertType(event.result, ParseResult);
			const result:ParseResult = event.result as ParseResult;
			trace("--BEGIN COMMENTS--");
			trace(result.comments);
			trace("--END COMMENTS--");
			const nodeGraph:NodeGraph = new NodeGraph(result.datasets);
			const data:Data = new NodeGraphDataConverter(nodeGraph).data;
			const vis:NodeGraphVis = new NodeGraphVis(data);
			UITestUtil.createTestWindow(vis, "NodeGraphVis", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}