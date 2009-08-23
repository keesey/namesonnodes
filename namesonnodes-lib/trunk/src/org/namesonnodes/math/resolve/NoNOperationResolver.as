package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathML;
	import a3lbmonkeybrain.calculia.collections.operations.Operation;
	import a3lbmonkeybrain.calculia.collections.operations.UnresolvableOperation;
	import a3lbmonkeybrain.calculia.mathml.AbstractOperationResolver;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.nodes.NodeGraph;
	import org.namesonnodes.math.operations.*;

	public final class NoNOperationResolver extends AbstractOperationResolver
	{
		private static const DEFINITION_URL_PATTERN:RegExp = /^http:\/\/namesonnodes.org\/ns\/math\/2009#def-/;
		private static const DEFINITION_HEADER:String = "http://namesonnodes.org/ns/math/2009#def-";
		private const operations:Dictionary = new Dictionary();
		public function NoNOperationResolver(nodeGraph:NodeGraph)
		{
			super();
			initOperations(nodeGraph);
		}
		override public function getOperation(mathML:XML) : Operation
		{
			default xml namespace = MathML.NAMESPACE.uri;
			if (mathML.localName() == "csymbol" && mathML.name().uri == MathML.NAMESPACE.uri)
			{
				const definitionURL:String = mathML.@definitionURL;
				if (definitionURL != null && DEFINITION_URL_PATTERN.test(definitionURL))
				{
					const operationName:String = definitionURL.substr(DEFINITION_HEADER.length);
					const op:* = operations[operationName];
					if (op is Operation)
						return op as Operation;
				}
			}
			return new UnresolvableOperation(mathML);
		}
		override protected function initOperationMap() : void
		{
		}
		private function initOperations(nodeGraph:NodeGraph):void
		{
			operations["Maximal"] = new Maximal(nodeGraph);
			operations["Minimal"] = new Minimal(nodeGraph);
			operations["PredecessorUnion"] = new PredecessorUnion(nodeGraph);
			operations["SuccessorUnion"] = new SuccessorUnion(nodeGraph);
			operations["PredecessorIntersection"] = new PredecessorIntersection(nodeGraph);
			operations["SuccessorIntersection"] = new SuccessorIntersection(nodeGraph);
			operations["SynapomorphicPredecessors"] = new SynapomorphicPredecessors(operations["PredecessorIntersection"] as PredecessorIntersection);
			operations["NodeBasedCladogen"] = new NodeBasedCladogen(operations["Maximal"] as Maximal, operations["PredecessorIntersection"] as PredecessorIntersection);
			operations["BranchBasedCladogen"] = new BranchBasedCladogen(operations["Minimal"] as Minimal, operations["PredecessorUnion"] as PredecessorUnion, operations["PredecessorIntersection"] as PredecessorIntersection);
			operations["ApomorphyBasedCladogen"] = new ApomorphyBasedCladogen(operations["Minimal"] as Minimal, operations["SynapomorphicPredecessors"] as SynapomorphicPredecessors);
			operations["Clade"] = new Clade(operations["Minimal"] as Minimal, operations["SuccessorUnion"] as SuccessorUnion, operations["SuccessorIntersection"] as SuccessorIntersection);
			operations["NodeBasedClade"] = new NodeBasedClade(operations["SuccessorUnion"] as SuccessorUnion, operations["NodeBasedCladogen"] as NodeBasedCladogen);
			operations["BranchBasedClade"] = new BranchBasedClade(operations["SuccessorUnion"] as SuccessorUnion, operations["PredecessorUnion"] as PredecessorUnion, operations["PredecessorIntersection"] as PredecessorIntersection);
			operations["ApomorphyBasedClade"] = new ApomorphyBasedClade(operations["SuccessorUnion"] as SuccessorUnion, operations["SynapomorphicPredecessors"] as SynapomorphicPredecessors);
			operations["CrownClade"] = new CrownClade(operations["NodeBasedClade"] as NodeBasedClade);
			operations["TotalClade"] = new TotalClade(operations["BranchBasedClade"] as BranchBasedClade, operations["CrownClade"] as CrownClade);
			operations["NodeBranchTriple"] = new NodeBranchTriple(operations["NodeBasedClade"] as NodeBasedClade, operations["BranchBasedClade"] as BranchBasedClade);
			// :TODO: TaxonBall
		}
	}
}