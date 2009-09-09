package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.collections.Set;
	import a3lbmonkeybrain.brainstem.resolve.Unresolvable;
	import a3lbmonkeybrain.brainstem.resolve.UnresolvableXML;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	
	public final class MathMLElementResolver implements XMLResolver
	{
		private var symbolResolver:XMLResolver;
		public function MathMLElementResolver(symbolResolver:XMLResolver = null)
		{
			super();
			this.symbolResolver = symbolResolver;
		}
		private function resolveApply(xml:XML):Object
		{
			if (xml.children().length() < 2)
				throw new MathMLError("An <apply> element has less than two child elements:\n" + xml);
			const containerTest:Object = resolveOperation(xml.children()[0] as XML);
			if (containerTest is Unresolvable)
				return containerTest;
			if (!(containerTest is MathMLContainer))
				return new UnresolvableXML(xml.children()[0] as XML);
			const container:MathMLContainer = containerTest as MathMLContainer;
			var i:uint = 0;
			for each (var child:XML in xml.children())
			{
				if (i == 0)
				{
					i++;
					continue;
				}
				const childElement:Object = resolveXML(child);
				if (childElement is MathMLElement)
				{
					var index:uint = (i++) - 1;
					while (container.canIncrementChildren && index >= container.numChildren)
						container.incrementChildren();
					container.setChildAt(childElement as MathMLElement, index);
				}
				else if (childElement is Unresolvable)
					return childElement;
				else
					return new UnresolvableXML(child);
			}
			return container;
		}
		private function resolveMath(xml:XML):Object
		{
			const container:MathMLContainer = new MathElement();
			var i:uint = 0;
			for each (var child:XML in xml.children())
			{
				const childElement:Object = resolveXML(child);
				if (childElement is MathMLElement)
				{
					var index:uint = i++;
					while (container.canIncrementChildren && index >= container.numChildren)
						container.incrementChildren();
					container.setChildAt(childElement as MathMLElement, index);
				}
				else if (childElement is Unresolvable)
					return childElement;
				else
					return new UnresolvableXML(child);
			}
			return container;
		}
		private function resolveOperation(xml:XML):Object
		{
			if (xml.name().uri != MathML.NAMESPACE.uri)
				return new UnresolvableXML(xml);
			if (xml.name() == MathML.AND)
				return new AndElement();
			if (xml.name() == MathML.EQ)
				return new EqElement();
			if (xml.name() == MathML.IMPLIES)
				return new ImpliesElement();
			if (xml.name() == MathML.INTERSECT)
				return new IntersectElement();
			if (xml.name() == MathML.NEQ)
				return new NEqElement();
			if (xml.name() == MathML.NOT)
				return new NotElement();
			if (xml.name() == MathML.NOTPRSUBSET)
				return new NotPrSubsetElement();
			if (xml.name() == MathML.NOTSUBSET)
				return new NotSubsetElement();
			if (xml.name() == MathML.OR)
				return new OrElement();
			if (xml.name() == MathML.PRSUBSET)
				return new PrSubsetElement();
			if (xml.name() == MathML.SETDIFF)
				return new SetDiffElement();
			if (xml.name() == MathML.SUBSET)
				return new SubsetElement();
			if (xml.name() == MathML.UNION)
				return new UnionElement();
			if (xml.name() == MathML.XOR)
				return new XOrElement();
			return new UnresolvableXML(xml);
		}
		private function resolvePiece(xml:XML, type:Class):Object
		{
			if (xml.children().length() != 2)
				throw new MathMLError("Invalid <piece> element:\n" + xml);
			const container:MathMLContainer = new PieceElement(type);
			for (var i:uint = 0; i < 2; ++i)
			{
				var childElement:Object = resolveXML(xml.children()[i]);
				if (childElement is MathMLElement)
				{
					var index:uint = i++;
					while (container.canIncrementChildren && index >= container.numChildren)
						container.incrementChildren();
					container.setChildAt(childElement as MathMLElement, index);
				}
				else if (childElement is Unresolvable)
					return childElement;
				else
					return new UnresolvableXML(xml);
			}
			return container;
		}
		private function resolvePiecewise(xml:XML):Object
		{
			default xml namespace = MathML.NAMESPACE.uri;
			var type:Class;
			if (xml.hasOwnProperty("@type"))
			{
				switch (String(xml.@type).toLowerCase())
				{
					case "set" :
					{
						type = Set;
						break;
					}
					case "boolean" :
					{
						type = Boolean;
						break;
					}
					default :
						type = Object;
				}
			}
			else
				type = Object;
			const container:MathMLContainer = new PiecewiseElement(type);
			const n:uint = xml.children().length();
			if (n < 2)
				throw new MathMLError("A piecewise construct must have at least two child elements:\n" + xml);
			var i:uint = 0;
			for each (var child:XML in xml.children())
			{
				var childElement:Object;
				var index:uint;
				if (i == n - 1)
				{
					if (child.name() == MathML.OTHERWISE)
					{
						childElement = resolveXML(child);
						if (childElement is Unresolvable)
							return childElement;
						else if (childElement is MathMLElement)
						{
							index = i++;
							while (container.canIncrementChildren && index >= container.numChildren)
								container.incrementChildren();
							container.setChildAt(childElement as MathMLElement, index);
						}
						else
							return new UnresolvableXML(child);
					}
					else
						throw new MathMLError("The last child element of a piecewise construct must be an <otherwise> element; found:\n" + child);
				}
				else if (child.name() == MathML.PIECE)
				{
					childElement = resolvePiece(child, type);
					if (childElement is Unresolvable)
						return childElement;
					else if (childElement is MathMLElement)
					{
						index = i++;
						while (container.canIncrementChildren && index >= container.numChildren)
							container.incrementChildren();
						container.setChildAt(childElement as MathMLElement, index);
					}
					else
						return new UnresolvableXML(child);
				}
				else
					throw new MathMLError("Expected a <piece> element; found:\n" + child);
			}
			return container;
		}
		public function resolveXML(xml:XML):Object
		{
			XML.ignoreWhitespace = true;
			default xml namespace = MathML.NAMESPACE;
			if (xml.name().uri != MathML.NAMESPACE.uri)
				return new UnresolvableXML(xml);
			if (xml.name() == MathML.APPLY)
				return resolveApply(xml);
			// :TODO: Declare
			else if (xml.name() == MathML.MATH)
				return resolveMath(xml);
			else if (xml.name() == MathML.CSYMBOL)
			{
				if (symbolResolver)
					return symbolResolver.resolveXML(xml);
				return new UnresolvableXML(xml);
			}
			else if (xml.name() == MathML.EMPTYSET)
				return new EmptySetElement();
			else if (xml.name() == MathML.FALSE)
				return new FalseElement();
			else if (xml.name() == MathML.PIECEWISE)
				return resolvePiecewise(xml);
			else if (xml.name() == MathML.TRUE)
				return new TrueElement();
			return new UnresolvableXML(xml);
		}
	}
}