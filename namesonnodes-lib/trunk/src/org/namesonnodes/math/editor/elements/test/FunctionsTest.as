package org.namesonnodes.math.editor.elements.test
{
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.math.editor.elements.incrementIdentifier;
	
	public class FunctionsTest extends TestCase
	{
		public function testIncrementIdentifier():void
		{
			var s:String = "";
			for (var i:uint = 0; i < 300; ++i)
			{
				s = incrementIdentifier(s);
				trace(s);
			} 
		}
	}
}