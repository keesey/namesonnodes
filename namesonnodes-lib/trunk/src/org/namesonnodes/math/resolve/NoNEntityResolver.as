package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	import a3lbmonkeybrain.brainstem.resolve.UnresolvableXML;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.entities.Taxon;

	public final class NoNEntityResolver implements XMLResolver
	{
		private var nodeGraph:NodeGraph;
		private var universalTaxon:Taxon;
		public function NoNEntityResolver(nodeGraph:NodeGraph)
		{
			super();
			assertNotNull(nodeGraph);
			this.nodeGraph = nodeGraph;
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
					{
						if (universalTaxon == null)
							universalTaxon = Taxon.fromFinestNodes(nodeGraph.allFinestNodes);
						return universalTaxon;
					}
					else
					{
						const nodeSet:FiniteSet = nodeGraph.interpretQName(definitionURL);
						if (nodeSet != null && !nodeSet.empty)
							return Taxon.fromFinestNodes(nodeSet);
					}
				}
			}
			return new UnresolvableXML(xml);
		}
	}
}