package org.namesonnodes.math.editor.elements
{
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
	}
}