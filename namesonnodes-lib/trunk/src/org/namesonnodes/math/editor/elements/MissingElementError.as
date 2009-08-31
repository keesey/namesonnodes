package org.namesonnodes.math.editor.elements
{
	public final class MissingElementError extends Error
	{
		private var _elements:Vector.<MathMLElement>;
		public function MissingElementError(elements:Vector.<MathMLElement>)
		{
			super((elements.length == 1 ? "An element has" : "Some elements have")
				+ " not been supplied.");
			_elements = elements;
		}
		public function get elements():Vector.<MathMLElement>
		{
			return _elements.concat();
		}
	}
}