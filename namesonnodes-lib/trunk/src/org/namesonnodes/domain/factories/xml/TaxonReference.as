package org.namesonnodes.domain.factories.xml
{
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	internal final class TaxonReference extends IdentifierReference
	{
		private var _qName:String;
		public function TaxonReference(qName:QName, source:Object, property:*, useEntity:Boolean = false)
		{
			super(source, property, useEntity);
			if (qName == null)
				throw new ArgumentError("Null qualified name.");
			_qName = qName.toString();
		}
		override protected function targetString() : String
		{
			return _qName;
		}
		override public function useDictionary(d:Dictionary) : Boolean
		{
			const i:TaxonIdentifier = d[_qName] as TaxonIdentifier;
			if (i == null)
				throw new Error("No taxon found for qualified name <" + _qName + ">.");
			if (useEntity && i.entity == null)
				return false;
			source[property] = useEntity ? i.entity : i;
			return true;
		}
	}
}