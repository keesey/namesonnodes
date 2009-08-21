package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.utils.Dictionary;

	internal class IdentifierReference
	{
		private var _property:*;
		private var _source:Object;
		private var _useEntity:Boolean;
		public function IdentifierReference(source:Object, property:*, useEntity:Boolean = false)
		{
			super();
			if (source == null)
				throw new ArgumentError("Null source object.");
			_source = source;
			_property = property;
			_useEntity = useEntity;
		}
		public final function get property():*
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
		public function useDictionary(d:Dictionary):Boolean
		{
			throw new AbstractMethodError();
		}
		private static function stringOrError(v:*):String
		{
			var s:String;
			try
			{
				s = String(v);
			}
			catch (e:Error)
			{
				s = "<" + e.name + ": " + e.message + ">";
			}
			return s;
		}
		protected function targetString():String
		{
			throw new AbstractMethodError();
		}
		public final function toString():String
		{
			var s:String = stringOrError(source);
			if (isNaN(property))
				s += "." + stringOrError(property);
			else
				s += "[" + property + "]";
			s += " = <" + targetString() + ">";
			if (useEntity)
				s += ".entity";
			return s;
		}
	}
}