package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.brainstem.resolve.UnresolvableXML;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import org.namesonnodes.domain.collections.DatasetCollection;

	public final class NoNEntityResolver implements XMLResolver
	{
		private var datasetCollection:DatasetCollection;
		public function NoNEntityResolver(datasetCollection:DatasetCollection)
		{
			super();
			assertNotNull(datasetCollection);
			this.datasetCollection = datasetCollection;
		}
		public function resolveXML(xml:XML):Object
		{
			default xml namespace = MathML.NAMESPACE.uri;
			if (xml.localName() == "csymbol" && xml.name().uri == MathML.NAMESPACE.uri)
			{
				const definitionURL:String = xml.@definitionURL;
				if (isNonEmptyString(definitionURL))
				{
					if (definitionURL == "http://namesonnodes.org/ns/math/2009#def-UniversalTaxon")
						return datasetCollection.universalTaxon;
					// :TODO:
					// else if (definitionURL == "http://namesonnodes.org/ns/math/2009#def-GraphRelatedness")
					// :TODO:
					// else if (definitionURL == "http://namesonnodes.org/ns/math/2009#def-DigraphParenthood")
					else
					{
						const taxon:FiniteSet = datasetCollection.interpretQName(definitionURL);
						if (taxon != null && !taxon.empty)
							return taxon;
					}
				}
			}
			return new UnresolvableXML(xml);
		}
	}
}