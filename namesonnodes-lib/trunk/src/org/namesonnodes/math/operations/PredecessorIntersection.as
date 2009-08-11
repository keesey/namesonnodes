package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.w3c.mathml.MathMLError;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;

	public final class PredecessorIntersection extends AbstractOperation
	{
		internal var datasetCollection:DatasetCollection;
		private const calcTable:CalcTable = new CalcTable();
		public function PredecessorIntersection(datasetCollection:DatasetCollection)
		{
			super();
			assertNotNull(datasetCollection);
			this.datasetCollection = datasetCollection;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 1, 1))
				return getUnresolvableArgument(args);
			const s:FiniteSet = args[0] as FiniteSet;
			if (s.empty)
				return EmptySet.INSTANCE;
			if (s.size == 1)
				return datasetCollection.predecessors(s.singleMember as Node);
			const a:Array = [CalcTable.argumentsToToken(s.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r;
			var result:FiniteSet;
			for each (var x:Node in s)
			{
				if (result == null)
					result = HashSet.fromObject(datasetCollection.predecessors(x));
				else
				{
					result = result.intersect(datasetCollection.predecessors(x)) as FiniteSet;
					if (result.empty)
					{
						result = EmptySet.INSTANCE;
						break;
					}
				}
			}
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String
		{
			return "predecessor intersection";
		}
	}
}