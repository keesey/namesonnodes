package org.namesonnodes.domain.factories.xml
{
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	internal final class TaxonReference extends IdentifierReference
	{
		private var _qName:String;
		public function TaxonReference(qName:QName, source:Object, property:String, useEntity:Boolean = false)
		{
			super(source, property, useEntity);
			if (qName == null)
				throw new ArgumentError("Null qualified name.");
		}
		override public function useDictionary(d:Dictionary) : void
		{
			const i:TaxonIdentifier = d[_qName] as TaxonIdentifier;
			if (i == null)
				throw new Error("No authority found for URI <" + _qName + ">.");
			source[property] = useEntity ? i.entity : i;
		}
	}
}