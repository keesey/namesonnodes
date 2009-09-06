package org.namesonnodes.math.editor.elements
{
	import mx.core.IFactory;
	
	public final class PiecewiseElementFactory implements IFactory
	{
		public var type:Class;
		public function PiecewiseElementFactory(type:Class = null)
		{
			super();
			this.type = type;
		}
		public function newInstance():*
		{
			return new PiecewiseElement(type);
		}
	}
}