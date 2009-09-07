package org.namesonnodes.math.editor.panels.test
{
	import a3lbmonkeybrain.brainstem.core.nullEventHandler;
	import a3lbmonkeybrain.brainstem.test.UITestUtil;
	
	import flexunit.framework.TestCase;
	
	import mx.core.ClassFactory;
	
	import org.namesonnodes.math.editor.elements.AndElement;
	import org.namesonnodes.math.editor.panels.ElementButton;
	import org.namesonnodes.math.editor.panels.ElementButtonSkin;
	
	public class ElementButtonTest extends TestCase
	{
		public function testElementButton():void
		{
			const button:ElementButton = new ElementButton();
			button.elementFactory = new ClassFactory(AndElement);
			UITestUtil.createTestWindow(button, "ElementButton", addAsync(nullEventHandler, int.MAX_VALUE));
		}
	}
}