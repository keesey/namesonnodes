package org.namesonbranchs.math.operations
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.calculia.collections.operations.AbstractOperation;
	import a3lbmonkeybrain.calculia.core.CalcTable;
	
	import org.namesonnodes.domain.collections.DatasetCollection;

	public final class TotalGroup extends AbstractOperation
	{
		private var calcTable:CalcTable = new CalcTable();
		private var branchBasedClade:BranchBasedClade;
		private var crownGroup:CrownGroup;
		public function TotalGroup(branchBasedClade:BranchBasedClade, crownGroup:CrownGroup)
		{
			super();
			assertNotNull(branchBasedClade);
			assertNotNull(crownGroup);
			if (branchBasedClade.datasetCollection != crownGroup.datasetCollection)
				throw new ArgumentError("Conflicting dataset collections.");
			this.branchBasedClade = branchBasedClade;
			this.crownGroup = crownGroup;
		}
		internal function get datasetCollection():DatasetCollection
		{
			return branchBasedClade.datasetCollection;
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
			const crown:FiniteSet = crownGroup.apply(args);
			var result:FiniteSet;
			if (crown.empty)
				result = EmptySet.INSTANCE;
			else
				result = branchBasedClade.apply([crown,
					extant.intersect(datasetCollection.universalTaxon.diff(crown))]);
			calcTable.setResult(this, a, result);
			return result;
		}
		public function toString():String 
		{
			return "total group"
		}
	}
}