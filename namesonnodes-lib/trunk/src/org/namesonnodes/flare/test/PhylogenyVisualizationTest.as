package org.namesonnodes.flare.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flare.vis.operator.layout.Layout;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.events.ProgressEvent;
	
	import flexunit.framework.TestCase;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.biofiles.ParseResult;
	import org.namesonnodes.commands.biofiles.nexus.NexusFormat;
	import org.namesonnodes.flare.PhylogenyVisualization;
	import org.namesonnodes.phylo.PhylogenyDatasetFactory;

	public class PhylogenyVisualizationTest extends TestCase
	{
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/Barrett_etal_2007b.nex",mimeType="application/octet-stream")]
		public static const FILE_BARRETT_ETAL_2007B:Class;
		public function PhylogenyVisualizationTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testCreateData():void
		{
			const format:NexusFormat = new NexusFormat();
			format.addEventListener(ResultEvent.RESULT, addAsync(onFormatResult, 45000));
			format.addEventListener(FaultEvent.FAULT, trace);
			format.addEventListener(ProgressEvent.PROGRESS, trace);
			format.invoke(new FILE_BARRETT_ETAL_2007B());
		}
		private function onFormatResult(event:ResultEvent):void
		{
			const result:ParseResult = event.result as ParseResult;
			const phylogenyFactory:PhylogenyDatasetFactory = new PhylogenyDatasetFactory();
			phylogenyFactory.addDatasets(result.datasets);
			const vis:PhylogenyVisualization = new PhylogenyVisualization();
			vis.phylogeny = phylogenyFactory.createPhylogeny();
			UITestUtil.createTestWindow(vis, "PhylogenyVisualization", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}