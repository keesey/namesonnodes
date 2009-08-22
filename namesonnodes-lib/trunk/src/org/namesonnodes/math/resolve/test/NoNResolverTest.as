package org.namesonnodes.math.resolve.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.relate.Equality;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;
	import org.namesonnodes.domain.factories.xml.DatasetCollectionFactory;
	import org.namesonnodes.math.resolve.NoNResolver;

	public class NoNResolverTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		private static var ENTITIES:Class;
		[Embed(source="resolveTests.xml",mimeType="application/octet-stream")]
		private static var RESOLVE_TESTS:Class;
		private var tests:XML;
		private var resolver:NoNResolver;
		private static function createEntities():DatasetCollection
		{
			const bytes:ByteArray = new ENTITIES() as ByteArray;
			const source:XML = new XML(bytes.readUTFBytes(bytes.length));
			return new DatasetCollectionFactory(source).createDatasetCollection();
		}
		private static function createTests():XML
		{
			const bytes:ByteArray = new RESOLVE_TESTS() as ByteArray;
			return new XML(bytes.readUTFBytes(bytes.length));
		}
		override public function setUp() : void
		{
			super.setUp();
			Node.registerPrefix(new Namespace("ICZN", "urn:isbn:0853010064"));
			Node.registerPrefix(new Namespace("test", "org.namesonnodes.math.resolve.test"));
			resolver = new NoNResolver(createEntities());
			tests = createTests();
		}
		override public function tearDown() : void
		{
			super.tearDown();
			resolver = null;
			tests = null;
		}
		private function traceTest(item:XML):void
		{
			const n:int = item.children().length();
			if (item.name() == MathML.APPLY && n >= 3 && item.children()[0].name() == MathML.EQ)
			{
				const args:Vector.<Object> = new Vector.<Object>(n - 1);
				for (var i:int = 1; i < n; ++i)
					args[i - 1] = resolver.resolveXML(item.children()[i]);
				trace("\t", args.join(" ?= "));
				if (args[0] is FiniteSet)
					for (i = 1; i < n - 1; ++i)
					{
						if (!Equality.equal(args[0], args[i]) && args[i] is FiniteSet)
						{
							trace("arg[0] − arg[" + i + "] =", Set(args[0]).diff(args[i]));
							trace("arg[" + i + "] − arg[0] =", Set(args[i]).diff(args[0]));
						}
					}
				else if (args[0] is FiniteList)
					for (i = 1; i < n - 1; ++i)
					{
						if (!Equality.equal(args[0], args[i]) && args[i] is FiniteList)
						{
							if (FiniteList(args[0]).size != FiniteList(args[i]).size)
								trace("size mismatch: size(arg[0]) = " + args[0].size + "; size(arg[" + i + "]) = " + args[i].size + ".");
							else for (var j:uint = 0; j < FiniteList(args[0]).size; ++j)
							{
								var a:Object = FiniteList(args[0]).getMember(j);
								var b:Object = FiniteList(args[i]).getMember(j);
								if (!Equality.equal(a, b))
								{
									trace("Mismatch at elements of index " + j + ".");
									if (a is FiniteSet && b is FiniteSet)
									{
										trace("a − b =", Set(a).diff(b));
										trace("b − a =", Set(b).diff(a));
									}
									else
										trace(a, "is not equal to", b + ".");
								}
							}
						}
					}
			}
			else trace("No equation found.");
		}
		public function testResolveXML():void
		{
			const errors:Array = [];
			try
			{
				var testNum:int = 0;
				const results:Array = [];
				var result:*;
				for each (var item:XML in tests.children())
				{
					trace("Test #" + (testNum++));
					traceTest(item);
					var start:int = getTimer();
					result = resolver.resolveXML(item);
					var end:int = getTimer();
					trace("\t", "Result:", result, "(" + (end - start) + " ms)");
					results.push(result);
				}
				testNum = 0;
				for each (result in results)
					if (result !== true)
						errors.push(testNum++);
					else
						testNum++;
			}
			catch (e:Error)
			{
				trace("Error in test #" + testNum + ".");
				trace(e.getStackTrace());
				throw e;
			}
			if (errors.length != 0)
				throw new Error("Failed test(s): " + errors.join(", "));
		}
	}
}