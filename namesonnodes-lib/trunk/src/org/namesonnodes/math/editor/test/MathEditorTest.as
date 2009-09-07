package org.namesonnodes.math.editor.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.factories.xml.XMLNodeGraphFactory;
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.editor.MathEditor;
	
	public class MathEditorTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		private static var ENTITIES:Class;
		public function testMathEditor():void
		{
			const bytes:ByteArray = new ENTITIES() as ByteArray;
			const source:XML = new XML(bytes.readUTFBytes(bytes.length));
			const nodeGraph:NodeGraph = new XMLNodeGraphFactory(source).createNodeGraph();
			const editor:MathEditor = new MathEditor();
			editor.nodeGraph = nodeGraph;
			editor.width = 900;
			editor.height = 800;
			UITestUtil.createTestWindow(editor, "MathEditor", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}