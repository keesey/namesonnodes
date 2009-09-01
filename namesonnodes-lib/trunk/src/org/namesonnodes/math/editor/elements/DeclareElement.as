package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.assert.assert;
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.utils.getQualifiedClassName;
	
	public final class DeclareElement extends AbstractUnaryContainer implements MathMLContainer
	{
		private var _identifier:String;
		private var _type:Class;
		public function DeclareElement(identifier:String, type:Class)
		{
			super();
			if (isNonEmptyString(identifier))
				identifier = "A";
			assertNotNull(type);
			_identifier = identifier;
			_type = type;
		}
		override protected function get cloneBase() : MathMLContainer
		{
			return new DeclareElement(incrementIdentifier(_identifier), _type);
		} 
		public function get identifier():String
		{
			return _identifier;
		}
		public function get label():String
		{
			return _identifier + " :=";
		}
		public function get mathML():XML
		{
			const xml:XML = <declare type={getQualifiedClassName(_type)} xmlns={MathML.NAMESPACE.uri}><ci xmlns={MathML.NAMESPACE.uri}>{_identifier}</ci></declare>;
			xml.appendChild(getChildAt(0).mathML);
			return xml;
		}
		public function get resultClass():Class
		{
			return null;
		}
		public function get toolTipText():String
		{
			return "Declaration: defines the variable \"" + _identifier + "\".";
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null || child.resultClass == _type && i == 0;
		}
		override protected function createMissing() : MissingElement
		{
			return new MissingElement(_type);
		}
		public static function incrementIdentifier(identifier:String, position:int = -1):String
		{
			if (isNonEmptyString(identifier))
			{
				identifier = identifier.toUpperCase();
				if (identifier.match(/^[A-Z]+$/))
				{
					const n:uint = identifier.length;
					if (position < 0)
						position = n + position;
					const c:String = identifier.charAt(position);
					if (c == "Z")
					{
						identifier = setCharAt(identifier, position, "A");
						if (position == 0)
							identifier = "A" + identifier;
						else
							identifier = incrementIdentifier(identifier, position - 1);
					}
					else
						identifier = setCharAt(identifier, position, String.fromCharCode(c.charCodeAt(0) + 1));
				}
			}
			return "A";
		}
		public static function setCharAt(s:String, position:uint, char:String):String
		{
			if (position == 0)
			{
				if (s.length == 1)
					return char;
				return char + s;
			}
			if (position == s.length - 1)
				return s.substr(0, position) + char;
			return s.substr(0, position) + char + s.substr(position + 1);
		}
	}
}