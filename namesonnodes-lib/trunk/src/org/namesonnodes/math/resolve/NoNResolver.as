package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.resolve.CompositeXMLResolver;
	import a3lbmonkeybrain.brainstem.resolve.Unresolvable;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.calculia.mathml.CompositeOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLIdentifierResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLResolver;
	
	import org.namesonnodes.domain.nodes.NodeGraph;

	public final class NoNResolver implements XMLResolver
	{
		private var mathMLResolver:MathMLResolver;
		private var entityResolver:XMLResolver;
		public function NoNResolver(nodeGraph:NodeGraph)
		{
			super();
			mathMLResolver = new MathMLResolver(new MathMLIdentifierResolver(),
				new CompositeOperationResolver([new MathMLOperationResolver(),
				new NoNOperationResolver(nodeGraph)]));
			entityResolver = new CompositeXMLResolver([mathMLResolver,
				new NoNEntityResolver(nodeGraph)]);
			mathMLResolver.entityResolver = entityResolver;
		}
		public function resolveXML(xml:XML):Object
		{
			if (xml == null)
				throw new ArgumentError("No XML to resolve.");
			var o:Object = mathMLResolver.resolveXML(xml);
			if (o is Unresolvable)
				 o = entityResolver.resolveXML(xml);
			return o;
		}
	}
}