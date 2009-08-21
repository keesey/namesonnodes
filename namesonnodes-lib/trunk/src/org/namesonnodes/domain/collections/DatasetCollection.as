package org.namesonnodes.domain.collections
{
	import a3lbmonkeybrain.brainstem.collections.EmptySet;
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.collections.VectorList;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.DistanceRow;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.RankDefinition;
	import org.namesonnodes.domain.entities.Synonymy;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class DatasetCollection
	{
		private var allFinestNodes:FiniteSet;
		private const datasetDistances:Dictionary = new Dictionary();
		private const datasets:MutableSet = new HashSet();
		private const finest:Dictionary = new Dictionary();
		private const generationDistances:Dictionary = new Dictionary();
		private const identifiers:Dictionary = new Dictionary();
		private const immediatePredecessorsTable:Dictionary = new Dictionary();
		private const immediateSuccessorsTable:Dictionary = new Dictionary();
		private const nodes:Dictionary = new Dictionary();
		private const pathsTable:Dictionary = new Dictionary();
		private const precedence:Dictionary = new Dictionary();
		private const predecessorsTable:Dictionary = new Dictionary();
		private const successorsTable:Dictionary = new Dictionary();
		private const traversed:MutableSet = new HashSet();
		public function DatasetCollection(entities:Object)
		{
			super();
			for each (var entity:Object in entities)
				if (entity is Dataset)
					this.datasets.add(entity as Dataset);
				else if (entity is TaxonIdentifier)
					addIdentifier(entity as TaxonIdentifier);
			initIdentifiers();
			initPhylogeny();
			initDistances();
		}
		public function get universalTaxon():FiniteSet
		{
			if (allFinestNodes == null)
			{
				allFinestNodes = EmptySet.INSTANCE;
				for each (var identifier:TaxonIdentifier in identifiers)
					allFinestNodes = allFinestNodes.union(interpretIdentifier(identifier)) as FiniteSet;
			}
			return allFinestNodes;
		}
		public function addIdentifier(id:TaxonIdentifier):void
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
				var matrix:Dictionary = datasetDistances[dataset.qName.toString()]
					= new Dictionary(); 
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
				if (a == b) return 0;
				const matrix:Dictionary = datasetDistances[datasetQName];
				if (matrix[a] is Dictionary)
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
					distances.push(d + generationDistances[a][a2]);
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
			const r:* = immediatePredecessorsTable[n];
			if (r is FiniteSet)
				return r as FiniteSet;
			return EmptySet.INSTANCE;
		}
		public function immediateSuccessors(n:Node):FiniteSet
		{
			const r:* = immediateSuccessorsTable[n];
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
			for each (var id:TaxonIdentifier in identifiers)
				if (!n.identifiers.has(id) && n.taxa.has(id.entity))
					n.addIdentifier(id);
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
							if (prcNode == sucNode)
								throw new ArgumentError("Phylogeny contains a loop.");
							var t:* = precedence[sucNode];
							if (!(t is Dictionary))
								t = precedence[sucNode] = new Dictionary();
							t[prcNode] = true;
							t = precedence[prcNode];
							if (t is Dictionary)
							{
								if (t[sucNode] === true)
									throw new ArgumentError("Phylogeny contains a cycle.");
							}
							else
								t = precedence[prcNode] = new Dictionary();
							t[sucNode] = false;
							var s:* = immediatePredecessorsTable[sucNode];
							if (!(s is MutableSet))
							{
								s = new HashSet();
								immediatePredecessorsTable[sucNode] = s;
							}
							MutableSet(s).add(prcNode)
							s = immediateSuccessorsTable[prcNode];
							if (!(s is MutableSet))
							{
								s = new HashSet();
								immediateSuccessorsTable[prcNode] = s;
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
			if (node == null)
				return EmptySet.INSTANCE;
			var r:* = finest[node];
			if (r is FiniteSet) return r as FiniteSet;
			const f:MutableSet = new HashSet();
			for each (var dataset:Dataset in datasets)
				for each (var inclusion:Inclusion in dataset.inclusions)
					if (node.taxa.has(inclusion.superset.entity))
						f.addMembers(finestNodes(findNode(inclusion.subset)));
			for each (var taxon:Taxon in node.taxa)
				if (taxon.definition is RankDefinition)
					for each (var type:TaxonIdentifier in RankDefinition(taxon.definition).types)
						f.addMembers(finestNodes(findNode(type)));
			if (f.empty)
				f.add(node);
			finest[node] = f;
			return f;
		}
		public function paths(prc:Node, suc:Node):FiniteSet /* .<FiniteList.<Node>> */
		{
			if (pathsTable[prc] is Dictionary)
			{
				const r:* = pathsTable[prc][suc];
				if (r is FiniteSet)
					return r as FiniteSet;
			}
			else
				pathsTable[prc] = new Dictionary();
			if (prc == suc)
				return HashSet.createSingleton(VectorList.fromObject([prc]));
			const result:MutableSet = new HashSet();
			for each (var prc2:Node in immediatePredecessors(suc))
			{
				for each (var subpath:FiniteList in paths(prc, prc2))
				{
					subpath = VectorList.fromObject(subpath.toVector().concat(suc));
					result.add(subpath);
				}
			}
			return (pathsTable[prc][suc] = result.empty ? EmptySet.INSTANCE : result) as FiniteSet;
		}
		public function precedes(a:Node, b:Node):Boolean
		{
			if (a == b || a == null || b == null)
				return false;
			var t:* = precedence[b];
			var v:*;
			if (t is Dictionary)
			{
				v = t[a];
				if (v === true)
					return true;
				if (v === false)
					return false;
			}
			else
				precedence[b] = t = new Dictionary();
			const parents:FiniteSet = immediatePredecessors(b);
			if (parents.empty)
				v = false;
			else
			{
				for each (var parent:Node in parents)
					if (precedes(a, parent))
					{
						v = true;
						break;
					}
				v = false;
			}
			t[a] = v;
			if (v)
			{
				t = precedence[a];
				if (t is Dictionary)
				{
					if (t[b] === true)
						throw new ArgumentError("Phylogeny contains a cycle.");
				}
				else
					t = precedence[a] = new Dictionary();
				t[b] = false;
			}
			return v;
		}
		public function precedesOrEquals(a:Node, b:Node):Boolean
		{
			if (a == b)
				return true;
			return precedes(a, b);
		}
		public function predecessors(x:Node):FiniteSet /*.<Node>*/
		{
			const r:* = predecessorsTable[x];
			if (r is FiniteSet)
				return r as FiniteSet;
			const result:MutableSet = HashSet.createSingleton(x);
			for each (var parent:Node in immediatePredecessors(x))
			{
				result.addMembers(predecessors(parent));
			}
			predecessorsTable[x] = result;
			return result;
		}
		public function succeeds(a:Node, b:Node):Boolean
		{
			return precedes(b, a);
		}
		public function succeedsOrEquals(a:Node, b:Node):Boolean
		{
			if (a == b)
				return true;
			return precedes(b, a);
		}
		public function successors(x:Node):FiniteSet /*.<Node>*/
		{
			const r:* = successorsTable[x];
			if (r is FiniteSet)
				return r as FiniteSet;
			const result:MutableSet = HashSet.createSingleton(x);
			for each (var child:Node in immediateSuccessors(x))
				result.addMembers(successors(child));
			predecessorsTable[x] = result;
			return result;
		}
	}
}