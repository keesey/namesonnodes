package org.namesonnodes.math.editor.elements 
{
	
	
	public class AbstractContainer extends AbstractElement
	{
		public function AbstractContainer()
		{
			super();
			if (!(this is MathMLContainer))
				throw new Error("Instantiation of a pseudo-abstract class.");
		}
		protected final function appendChildrenMathML(mathML:XML):void
		{
			const n:uint = MathMLContainer(this).numChildren;
			var missing:Vector.<MathMLElement>;
			for (var i:uint = 0; i < n; ++i)
			{
				try
				{
					mathML.appendChild(MathMLContainer(this).getChildAt(i).mathML);
				}
				catch (e:MissingElementError)
				{
					missing = missing ? missing.concat(e.elements) : e.elements;
				}
			}
			if (missing != null && missing.length != 0)
				throw new MissingElementError(missing);
		}
		public function getChildLabelAt(i:uint):String
		{
			return "";
		}
	}
}