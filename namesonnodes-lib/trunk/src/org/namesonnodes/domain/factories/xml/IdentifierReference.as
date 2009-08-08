package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.utils.Dictionary;

	internal class IdentifierReference
	{
		private var _property:String;
		private var _source:Object;
		private var _useEntity:Boolean;
		public function IdentifierReference(source:Object, property:String, useEntity:Boolean = false)
		{
			super();
			if (source == null)
				throw new ArgumentError("Null source object.");
			if (!source.hasOwnProperty(property))
				throw new ArgumentError("Invalid property for " + source + ": \"" + property + "\".");
			_source = source;
			_property = property;
			_useEntity = useEntity;
		}
		public final function get property():String
		{
			return _property;
		}
		public final function get source():Object
		{
			return _source;
		}
		public final function get useEntity():Boolean
		{
			return _useEntity;
		}
		public function useDictionary(d:Dictionary):void
		{
			throw new AbstractMethodError();
		}
	}
}