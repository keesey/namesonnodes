package org.namesonnodes.math.editor.elements
{
	public final class MissingElement extends AbstractElement implements MathMLElement
	{
		private var _resultClass:Class;
		public function MissingElement(resultClass:Class)
		{
			super();
			_resultClass = resultClass;
		}
		public function get label():String
		{
			return "\u2026";
		}
		public function get mathML():XML
		{
			throw new MissingElementError(Vector.<MathMLElement>([this]));
		}
		public function get resultClass() : Class
		{
			return _resultClass;
		}
		public function get toolTipText() : String
		{
			return "Please drag and drop an appropriate element to this slot.";
		}
		public function clone():MathMLElement
		{
			return new MissingElement(resultClass);
		}
	}
}