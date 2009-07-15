package org.namesonnodes.commands.biofiles.newick.test
{
	import a3lbmonkeybrain.brainstem.assert.assertType;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.biofiles.ParseResult;
	import org.namesonnodes.commands.biofiles.newick.NewickFormat;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;

	public class NewickFormatTest extends TestCase
	{
		public function NewickFormatTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testInvoke():void
		{
			testInvokeString("(A:0.1,B:0.2,(C:0.3,D:0.4)E:0.5)F");  
			testInvokeString("(Bovine:0.69395,(Gibbon:0.36079,(Orang:0.33636,(Gorilla:0.17147,(Chimp:0.19268, Human:0.11927):0.08386):0.06124):0.15057):0.54939,Mouse:1.21460):0.10");  
			testInvokeString("(Bovine:0.69395,(Gibbon:0.36079,(Orang:0.33636,(Gorilla:0.17147,(Chimp:0.19268, Human:0.11927)Hominini:0.08386)Homininae:0.06124)Hominidae:0.15057)Hominoidea:0.54939,Mouse:1.21460)Boreoeutheria:0.10");  
		}
		private function testInvokeString(s:String):void
		{
			const bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(s, "us-ascii");
			const format:NewickFormat = new NewickFormat();
			format.addEventListener(ResultEvent.RESULT, addAsync(onFormatResult, 10000));
			format.invoke(bytes);
		}
		private function onFormatResult(event:ResultEvent):void
		{
			assertType(event.result, ParseResult);
			const result:ParseResult = event.result as ParseResult;
			assertEquals(1, result.datasets.length);
			for each (var dataset:Dataset in result.datasets)
			{
				trace("DATASET: " + dataset.label.name);
				for each (var heredity:Heredity in dataset.heredities)
					trace("\t" + heredity.predecessor.localName + " -> " + heredity.successor.localName);
			}
		}
	}
}