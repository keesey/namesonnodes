package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.calculia.mathml.CompositeOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLIdentifierResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLOperationResolver;
	import a3lbmonkeybrain.calculia.mathml.MathMLResolver;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.math.operations.NoNOperationResolver;

	public final class NoNResolver implements XMLResolver
	{
		private var mathMLResolver:XMLResolver;
		public function NoNResolver(datasetCollection:DatasetCollection)
		{
			super();
			mathMLResolver = new MathMLResolver(new MathMLIdentifierResolver(),
				new CompositeOperationResolver([new MathMLOperationResolver(),
				new NoNOperationResolver(datasetCollection)]),
				new NoNEntityResolver(datasetCollection));
		}
		public function resolveXML(xml:XML):Object
		{
			return mathMLResolver.resolveXML(xml);
		}
	}
}