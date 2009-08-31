package org.namesonnodes.math.editor.panels.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.math.editor.panels.LogicPanel;
	
	public class LogicPanelTest extends TestCase
	{
		public function testLogicPanel():void
		{
			UITestUtil.createTestWindow(new LogicPanel(), "LogicPanel", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}