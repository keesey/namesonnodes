package org.namesonnodes.math.editor.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.math.editor.MathEditor;
	
	public class MathEditorTest extends TestCase
	{
		public function testMathEditor():void
		{
			UITestUtil.createTestWindow(new MathEditor(), "MathEditor", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}