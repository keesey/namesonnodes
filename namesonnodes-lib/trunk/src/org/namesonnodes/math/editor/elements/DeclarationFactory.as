package org.namesonnodes.math.editor.elements
{
	import mx.core.IFactory;
	
	public final class DeclarationFactory implements IFactory
	{
		public var identifierSource:*;
		public var identifierProperty:*;
		public var type:Class;
		public function DeclarationFactory()
		{
			super();
		}
		public function newInstance():*
		{
			var identifier:String;
			if (identifierSource is Object && identifierProperty is Object)
			{
				identifier = identifierSource[identifierProperty] as String;
				identifierSource[identifierProperty] = DeclareElement.incrementIdentifier(identifier);
			}
			else
				identifier = "x";
			return new DeclareElement(identifier, type);
		}
	}
}