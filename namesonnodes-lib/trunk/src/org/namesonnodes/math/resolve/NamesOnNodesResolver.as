package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.calculia.mathml.CompositeOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLIdentifierResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLResolver;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.math.operations.NamesOnNodesOperationResolver;

	public final class NamesOnNodesResolver implements XMLResolver
	{
		private var mathMLResolver:XMLResolver;
		public function NamesOnNodesResolver(datasetCollection:DatasetCollection)
		{
			super();
			mathMLResolver = new MathMLResolver(new MathMLIdentifierResolver(),
				new CompositeOperationResolver([new MathMLOperationResolver(),
				new NamesOnNodesOperationResolver(datasetCollection)]),
				new NamesOnNodesEntityResolver(datasetCollection));
		}
		public function resolveXML(xml:XML):Object
		{
			return mathMLResolver.resolveXML(xml);
		}
	}
}