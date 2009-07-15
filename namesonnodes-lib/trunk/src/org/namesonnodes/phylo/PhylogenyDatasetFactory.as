package org.namesonnodes.phylo
{
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.filter.filterType;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.Synonymy;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	[Event(name = "change", type = "flash.events.Event")]
	public final class PhylogenyDatasetFactory extends EventDispatcher
	{
		private const datasets:ArrayCollection = new ArrayCollection();
		private const taxonVertexMap:Dictionary = new Dictionary();
		public function PhylogenyDatasetFactory()
		{
			super();
			datasets.filterFunction = filterType(Dataset);
			datasets.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
		public function addDatasets(datasets:Object):void
		{
			for each (var dataset:Dataset in datasets)
				this.datasets.addItem(dataset);
		}
		public function addDataset(dataset:Dataset):void
		{
			datasets.addItem(dataset);
		}
		private function getVertex(identifier:TaxonIdentifier):FiniteSet
		{
			const v:* = taxonVertexMap[identifier.entity];
			if (v is MutableSet)
			{
				MutableSet(v).add(identifier);
				return v as FiniteSet;
			}
			return (taxonVertexMap[identifier.entity] = HashSet.createSingleton(identifier))
				as FiniteSet;
		}
		public function createPhylogeny():Phylogeny
		{
			const phylogeny:Phylogeny = new Phylogeny();
			for each (var dataset:Dataset in datasets)
			{
				for each (var synonymy:Synonymy in dataset.synonymies)
				{
					var synonyms:FiniteSet = HashSet.fromObject(synonymy.synonyms);
					for each (var identifier:TaxonIdentifier in synonymy.synonyms)
						taxonVertexMap[identifier] = synonyms;
				}	
			}
			for each (dataset in datasets)
			{
				for each (var inclusion:Inclusion in dataset.inclusions)
					phylogeny._inclusionGraph.createEdge(getVertex(inclusion.superset),
						getVertex(inclusion.subset));
				for each (var heredity:Heredity in dataset.heredities)
					// :TODO: adjust weight
					phylogeny._heredityGraph.createWeightedEdge(getVertex(heredity.predecessor),
						getVertex(heredity.successor), heredity.weight);
			}
			phylogeny.updateFinest();
			for each (var arc:FiniteList in phylogeny._heredityGraph.edges)
			{
				var head:FiniteSet = arc.getMember(0) as FiniteSet;
				var tail:FiniteSet = arc.getMember(1) as FiniteSet;
				var headVertices:FiniteSet;
				var tailVertices:FiniteSet;
				if (!phylogeny.finestSet.has(head))
					headVertices = phylogeny._inclusionGraph.maximal(phylogeny._inclusionGraph.successors(head));
				if (!phylogeny.finestSet.has(tail))
					tailVertices = phylogeny._inclusionGraph.maximal(phylogeny._inclusionGraph.successors(tail));
				if (headVertices)
				{
					phylogeny._heredityGraph.removeEdge(arc);
					var weighted:Boolean = arc.size >= 3;
					var weight:Number = weighted ? arc.getMember(2) as Number : NaN;
					if (tailVertices)
					{
						for each (var headVertex:FiniteSet in headVertices)
							for each (var tailVertex:FiniteSet in tailVertices)
								if (weighted)
									phylogeny._heredityGraph.createWeightedEdge(headVertex, tailVertex, weight);
								else
									phylogeny._heredityGraph.createEdge(headVertex, tailVertex);
					}
					else
					{
						tailVertex = arc.getMember(1) as FiniteSet;
						for each (headVertex in headVertices)
							if (weighted)
								phylogeny._heredityGraph.createWeightedEdge(headVertex, tailVertex, weight);
							else
								phylogeny._heredityGraph.createEdge(headVertex, tailVertex);
					}
				}
				else if (tailVertices)
				{
					phylogeny._heredityGraph.removeEdge(arc);
					weight = arc.getMember(2) as Number;
					headVertex = arc.getMember(1) as FiniteSet;
					for each (tailVertex in tailVertices)
						if (weighted)
							phylogeny._heredityGraph.createWeightedEdge(headVertex, tailVertex, weight);
						else
							phylogeny._heredityGraph.createEdge(headVertex, tailVertex);
				}
			}
			return phylogeny;
		}
		private function onCollectionChange(event:CollectionEvent):void
		{
			if (hasEventListener(Event.CHANGE))
				dispatchEvent(new Event(Event.CHANGE));
		}
	}
}