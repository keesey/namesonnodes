package org.namesonnodes.math.resolve.test
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.utils.ByteArray;
	
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
		}
		public function testResolveXML():void
		{
			try
			{
				default xml namespace = MathML.NAMESPACE.uri;
				const resolver:NoNResolver = new NoNResolver(createEntities());
				const tests:XML = createTests();
				var testNum:uint = 0;
				const errors:Array = [];
				const results:Object = resolver.resolveXML(tests);
				for each (var result:* in results)
					if (result !== true)
						errors.push(testNum++);
					else
						testNum++;
				if (errors.length != 0)
					throw new Error("Failed test(s): " + errors.join(", "));
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
				throw e;
			}
		}
	}
}