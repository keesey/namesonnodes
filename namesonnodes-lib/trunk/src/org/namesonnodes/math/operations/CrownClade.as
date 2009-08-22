package org.namesonnodes.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.collections.DatasetCollection;

	public final class CrownClade extends AbstractOperation
	{
		private var calcTable:CalcTable = new CalcTable();
		private var nodeBasedClade:NodeBasedClade;
		public function CrownClade(nodeBasedClade:NodeBasedClade)
		{
			super();
			assertNotNull(nodeBasedClade);
			this.nodeBasedClade = nodeBasedClade;
		}
		internal function get datasetCollection():DatasetCollection
		{
			return nodeBasedClade.datasetCollection;
		}
		override public function apply(args:Array) : Object
		{
			if (!checkArguments(args, FiniteSet, 2, 2))
				return getUnresolvableArgument(args);
			const specifiers:FiniteSet = args[0] as FiniteSet;
			const extant:FiniteSet = args[1] as FiniteSet;
			const a:Array = [CalcTable.argumentsToToken(specifiers.toArray()), CalcTable.argumentsToToken(extant.toArray())];
			const r:* = calcTable.getResult(this, a);
			if (r is FiniteSet)
				return r as FiniteSet;
			const result:Object = nodeBasedClade.apply([specifiers.intersect(extant)]);
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String 
		{
			return "crown group"
		}
	}
}