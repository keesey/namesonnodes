package org.namesonnodes.math.resolve.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.relate.Equality;
	import a3lbmonkeybrain.brainstem.resolve.Unresolvable;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
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
		public function testResolveXML():void
		{
			try
			{
				default xml namespace = MathML.NAMESPACE.uri;
				const resolver:NoNResolver = new NoNResolver(createEntities());
				const tests:XML = createTests();
				trace("Number of tests: " + tests.apply.length());
				for each (var apply:XML in tests.apply)
				{
					const l:int = apply.children().length();
					if (l > 0 && apply.children()[0].name() == MathML.EQ)
					{
						if (l < 3)
							throw new MathMLError("Operation 'eq' requires at least two arguments.");
						const args:Vector.<Object> = new Vector.<Object>(l - 1);
						for (var i:uint = 1; i < l; ++i)
						{
							var o:Object = resolver.resolveXML(apply.children()[i] as XML);
							if (o is Unresolvable)
								throw new Error("Cannot resolve XML: " + o);
							args[i - 1] = o;
						}
						trace("Testing for equality to: " + args[0]);
						for (i = 1; i < l - 1; ++i)
						{
							trace("Argument #" + i + ": " + args[i]);
							if (!Equality.equal(args[0], args[i]))
							{
								if (args[0] is FiniteSet && args[i] is FiniteSet)
								{
									trace("#0 - #" + i  + ": " + Set(args[0]).diff(args[i]));
									trace("#" + i + " - #0: " + Set(args[i]).diff(args[0]));
								}
								throw new Error("Expected equality: " + args[0] + " ≠ " + args[i]);
							}
						}
					}
				}
			}
			catch (e:Error)
			{
				trace(e.name + ": " + e.message);
				trace(e.getStackTrace());
				throw e;
			}
		}
	}
}