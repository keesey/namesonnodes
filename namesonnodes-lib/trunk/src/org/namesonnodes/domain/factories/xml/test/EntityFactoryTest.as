package org.namesonnodes.domain.factories.xml.test
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.entities.AbstractQualified;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.factories.xml.EntityFactory;

	public class EntityFactoryTest extends TestCase
	{
		[Embed(source="entities.xml",mimeType="application/octet-stream")]
		public var source:Class;
		public function EntityFactoryTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function readXMLBytes(bytes:ByteArray):XML
		{
			return new XML(bytes.readUTFBytes(bytes.length));
		}
		public function testReadEntities():void
		{
			const xml:XML = readXMLBytes(new source() as ByteArray);
			assertEquals(18, xml.children().length());
			const factory:EntityFactory = new EntityFactory(xml);
			const entities:Vector.<Persistent> = factory.createEntities();
			for each (var entity:Persistent in entities)
			{
				if (entity is AbstractQualified)
					trace(AbstractQualified(entity).qName);
				else if (entity is AuthorityIdentifier)
					trace(AuthorityIdentifier(entity).uri);
				else
					trace("WARNING: Unknown entity type: " + entity);
			}
			assertEquals(18, entities.length);
		}
	}
}