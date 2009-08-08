package org.namesonnodes.domain.factories.xml
{
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.AuthorityIdentifier;

	internal final class AuthorityReference extends IdentifierReference
	{
		private var _uri:String;
		public function AuthorityReference(uri:String, source:Object, property:*, useEntity:Boolean = false)
		{
			super(source, property, useEntity);
			if (uri == null)
				throw new ArgumentError("Null URI.");
		}
		override public function useDictionary(d:Dictionary) : void
		{
			const i:AuthorityIdentifier = d[_uri] as AuthorityIdentifier;
			if (i == null)
				throw new Error("No authority found for URI <" + _uri + ">.");
			source[property] = useEntity ? i.entity : i;
		}
	}
}