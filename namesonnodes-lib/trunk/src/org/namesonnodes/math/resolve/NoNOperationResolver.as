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
			const max:Maximal = new Maximal(nodeGraph);
			const min:Minimal = new Minimal(nodeGraph);
			const prcIntersect:PredecessorIntersection = new PredecessorIntersection(nodeGraph);
			const prcUnion:PredecessorUnion = new PredecessorUnion(nodeGraph);
			const sucIntersect:SuccessorIntersection = new SuccessorIntersection(nodeGraph);
			const sucUnion:SuccessorUnion = new SuccessorUnion(nodeGraph);
			const synPrc:SynapomorphicPredecessors = new SynapomorphicPredecessors(prcIntersect);
			const nodeCladogen:NodeBasedCladogen = new NodeBasedCladogen(max, prcIntersect);
			const nodeClade:NodeBasedClade = new NodeBasedClade(sucUnion, nodeCladogen);
			const branchClade:BranchBasedClade = new BranchBasedClade(sucUnion, prcUnion, prcIntersect);
			const crown:CrownClade = new CrownClade(nodeClade);
			operations["Maximal"] = max;
			operations["Minimal"] = min;
			operations["PredecessorUnion"] = prcUnion;
			operations["SuccessorUnion"] = new SuccessorUnion(nodeGraph);
			operations["PredecessorIntersection"] = prcIntersect;
			operations["SuccessorIntersection"] = sucIntersect;
			operations["SynapomorphicPredecessors"] = synPrc;
			operations["NodeBasedCladogen"] = nodeCladogen;
			operations["BranchBasedCladogen"] = new BranchBasedCladogen(min, prcUnion, prcIntersect);
			operations["ApomorphyBasedCladogen"] = new ApomorphyBasedCladogen(min, synPrc);
			operations["Clade"] = new Clade(min, sucUnion, sucIntersect);
			operations["NodeBasedClade"] = nodeClade;
			operations["BranchBasedClade"] = branchClade;
			operations["ApomorphyBasedClade"] = new ApomorphyBasedClade(sucUnion, synPrc);
			operations["CrownClade"] = crown;
			operations["TotalClade"] = new TotalClade(branchClade, crown);
		}
	}
}