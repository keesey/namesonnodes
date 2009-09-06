package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import flash.utils.getQualifiedClassName;
	
	import org.namesonnodes.utils.parseQName;
	
	public final class DeclareElement extends AbstractUnaryContainer implements MathMLContainer, TypedElement
	{
		private var _identifier:String;
		private var _type:Class;
		public function DeclareElement(identifier:String, type:Class)
		{
			super();
			if (isNonEmptyString(identifier))
				identifier = "X";
			assertNotNull(type);
			_identifier = identifier;
			_type = type;
			setChildAt(createMissing(), 0);
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
			return _identifier + " \u2254";
		}
		public function get mathML():XML
		{
			const typeName:QName = parseQName(getQualifiedClassName(_type));
			const xml:XML = <declare type={typeName.localName} xmlns={MathML.NAMESPACE.uri}><ci xmlns={MathML.NAMESPACE.uri} type={typeName.localName}>{_identifier}</ci></declare>;
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
		public function get type():Class
		{
			return _type;
		}
		public function acceptChildAt(child:MathMLElement, i:uint):Boolean
		{
			return child != null || child.resultClass == _type && i == 0;
		}
		override protected function createMissing() : MissingElement
		{
			return new MissingElement(_type || Object);
		}
	}
}