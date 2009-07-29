package org.namesonnodes.domain.collections
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.DistanceRow;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.Synonymy;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class DatasetCollection
	{
		private const datasetDistances:Dictionary = new Dictionary();
		private const datasets:MutableSet = new HashSet();
		private const finest:Dictionary = new Dictionary();
		private const generationDistances:Dictionary = new Dictionary();
		private const identifiers:Dictionary = new Dictionary();
		private const nodes:Dictionary = new Dictionary();
		private const predecessors:Dictionary = new Dictionary();
		private const successors:Dictionary = new Dictionary();
		private const traversed:MutableSet = new HashSet();
		public function DatasetCollection(datasets:Object)
		{
			super();
			for each (var dataset:Dataset in datasets)
				this.datasets.add(dataset);
			initIdentifiers();
			initPhylogeny();
			initDistances();
		}
		private function addIdentifier(id:TaxonIdentifier):void
		{
			identifiers[id.qName.toString()] = id;
		}
		private function initIdentifiers():void
		{
			for each (var dataset:Dataset in datasets)
			{
				for each (var row:DistanceRow in dataset.distanceRows)
				{
					addIdentifier(row.a);
					addIdentifier(row.b);
				}
				for each (var heredity:Heredity in dataset.heredities)
				{
					addIdentifier(heredity.predecessor);
					addIdentifier(heredity.successor);
				}
				for each (var inclusion:Inclusion in dataset.inclusions)
				{
					addIdentifier(inclusion.superset);
					addIdentifier(inclusion.subset);
				}
				for each (var synonymy:Synonymy in dataset.synonymies)
					for each (var id:TaxonIdentifier in synonymy.synonyms)
						addIdentifier(id);
			}
		}
		private function initDistances():void
		{
			for each (var dataset:Dataset in datasets)
			{
				if (dataset.distanceRows.length == 0)
					continue;
				datasetDistances[dataset.qName.toString()] = new Dictionary();
				var matrix:Dictionary = datasetDistances[dataset.qName.toString()]; 
				for each (var row:DistanceRow in dataset.distanceRows)
					for each (var a:Node in interpretIdentifier(row.a))
						for each (var b:Node in interpretIdentifier(row.b))
							if (a != b)
							{
								if (!(matrix[a] is Dictionary))
									matrix[a] = new Dictionary();
								if (!(matrix[b] is Dictionary))
									matrix[b] = new Dictionary();
								matrix[a][b] = row.distance;
								matrix[b][a] = row.distance;
							}
			}
		}
		public function datasetDistance(datasetQName:String, a:Node, b:Node):Number
		{
			if (datasetDistances[datasetQName] is Dictionary)
			{
				const matrix:Dictionary = datasetDistances[datasetQName];
				if (matrix[a] is Dictionary)
					if (matrix[a][b] is Number)
						return matrix[a][b] as Number;
			}
			return NaN;
		}
		public function generationDistance(a:Node, b:Node):int
		{
			if (a == b)
				return 0;
			if (!(generationDistances[a] is Dictionary) || !(generationDistances[b] is Dictionary))
				return -1;
			if (generationDistances[a][b] != undefined)
				return generationDistances[a][b] as int;
			var distances:Vector.<int> = new Vector.<int>();
			traversed.add(a);
			var d:int;
			for (var a2:* in generationDistances[a])
			{
				if (traversed.has(a2))
					continue;
				d = generationDistance(a2 as Node, b);
				if (d >= 0)
					distances.push(d);
			}
			traversed.remove(a);
			const n:uint = distances.length;
			if (n == 0)
				d = -1;
			else if (n == 1)
				d = distances[0];
			else
			{
				d = int.MAX_VALUE;
				for each (var d2:int in distances)
					d = d2 < d ? d2 : d;
			}
			generationDistances[a][b] = d;
			generationDistances[b][a] = d;
			return d;
		}
		public function immediatePredecessors(n:Node):FiniteSet
		{
			const r:* = predecessors[n];
			if (r is FiniteSet)
				return r as FiniteSet;
			return EmptySet.INSTANCE;
		}
		public function immediateSuccessors(n:Node):FiniteSet
		{
			const r:* = successors[n];
			if (r is FiniteSet)
				return r as FiniteSet;
			return EmptySet.INSTANCE;
		}
		private function findNode(identifier:TaxonIdentifier):Node
		{
			const r:* = nodes[identifier.entity];
			if (r is Node)
				return r as Node;
			const n:Node = new Node();
			n.addIdentifier(identifier);
			nodes[identifier.entity] = n;
			for each (var dataset:Dataset in datasets)
			{
				var useDistances:Boolean = !isNaN(dataset.weightPerGeneration) && dataset.weightPerGeneration != 0.0;
				if (useDistances)
					for each (var heredity:Heredity in dataset.heredities)
						if (n.taxa.has(heredity.predecessor.entity))
						{
							if (heredity.weight / dataset.weightPerGeneration <= 0)
							{
								n.addIdentifier(heredity.successor)
								nodes[heredity.successor.entity] = n;
							}
						}
						else if (n.taxa.has(heredity.successor.entity))
						{
							if (heredity.weight / dataset.weightPerGeneration <= 0)
							{
								n.addIdentifier(heredity.predecessor)
								nodes[heredity.predecessor.entity] = n;
							}
						}
			}
			for each (dataset in datasets)
				for each (var synonymy:Synonymy in dataset.synonymies)
					for each (var synonym:TaxonIdentifier in synonymy.synonyms)
						if (n.taxa.has(synonym.entity))
						{
							for each (var synonym2:TaxonIdentifier in synonymy.synonyms)
							{
								n.addIdentifier(synonym2);
								nodes[synonym2.entity] = n;
							}
							break;
						}
			return n;
		}
		public function interpretQName(qName:String):FiniteSet /* .<Node> */
		{
			const identifier:TaxonIdentifier = identifiers[qName] as TaxonIdentifier;
			return interpretIdentifier(identifier);
		}
		private function interpretIdentifier(identifier:TaxonIdentifier):FiniteSet /* .<Node> */
		{
			if (identifier == null)
				return null;
			const node:Node = findNode(identifier);
			return finestNodes(node);
		}
		private function initPhylogeny():void
		{
			for each (var dataset:Dataset in datasets)
			{
				var useDistances:Boolean = !isNaN(dataset.weightPerGeneration) && dataset.weightPerGeneration != 0.0;
				for each (var heredity:Heredity in dataset.heredities)
				{
					var prc:FiniteSet = interpretIdentifier(heredity.predecessor);
					var suc:FiniteSet = interpretIdentifier(heredity.successor);
					var distance:int = -1;
					if (useDistances)
						distance = Math.max(0, Math.ceil(heredity.weight / dataset.weightPerGeneration));
					for each (var prcNode:Node in prc)
						for each (var sucNode:Node in suc)
						{
							var s:* = predecessors[sucNode];
							if (!(s is MutableSet))
							{
								s = new HashSet();
								predecessors[sucNode] = s;
							}
							MutableSet(s).add(prcNode)
							s = successors[prcNode];
							if (!(s is MutableSet))
							{
								s = new HashSet();
								successors[prcNode] = s;
							}
							MutableSet(s).add(sucNode);
							if (useDistances)
							{
								if (generationDistances[prcNode] == undefined)
									generationDistances[prcNode] = new Dictionary();
								if (generationDistances[sucNode] == undefined)
									generationDistances[sucNode] = new Dictionary();
								generationDistances[prcNode][sucNode] = distance;
								generationDistances[sucNode][prcNode] = distance;
							}
						}
				}
			}
		}
		private function finestNodes(node:Node):FiniteSet /* .<Node> */
		{
			var r:* = finest[node];
			if (r is FiniteSet) return r as FiniteSet;
			const f:MutableSet = new HashSet();
			for each (var dataset:Dataset in datasets)
				for each (var inclusion:Inclusion in dataset.inclusions)
					if (node.taxa.has(inclusion.superset.entity))
						f.addMembers(finestNodes(findNode(inclusion.subset)));
			if (f.empty)
				f.add(node);
			finest[node] = f;
			return f;
		}
	}
}