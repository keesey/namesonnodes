package org.namesonnodes.math.graphs
{
	import a3lbmonkeybrain.brainstem.collections.FiniteList;
	import a3lbmonkeybrain.calculia.collections.graphs.AcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.Graph;
	import a3lbmonkeybrain.calculia.collections.graphs.exporters.GraphExporter;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Definition;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class DatasetGraphExporter implements GraphExporter
	{
		private var _inclusionMode:Boolean = false;
		private var definitionFactory:IFactory;
		private var localNamePrefix:String;
		private var unnamedIndex:uint = 0;
		private var _vertexMap:Dictionary;
		public function DatasetGraphExporter(localNamePrefix:String = "", definitionfactory:IFactory = null)
		{
			super();
			this.definitionFactory = definitionFactory;
			this.localNamePrefix = localNamePrefix.replace(/([^:])$/, "$1:");
		}

		public function get vertexMap():Dictionary
		{
			if (_vertexMap == null)
				_vertexMap = new Dictionary();
			return _vertexMap;
		}

		public function set vertexMap(v:Dictionary):void
		{
			_vertexMap = v;
		}

		public function get heredityMode():Boolean
		{
			return !_inclusionMode;
		}
		public function set heredityMode(v:Boolean):void
		{
			_inclusionMode = !v;
		}
		public function get inclusionMode():Boolean
		{
			return _inclusionMode;
		}

		public function set inclusionMode(v:Boolean):void
		{
			_inclusionMode = v;
		}

		public function export(g:Graph):ByteArray
		{
			if (!(g is AcyclicGraph))
				throw new ArgumentError("Can only export acyclic graphs.");
			const dataset:Dataset = inclusionMode
				? exportInclusionDataset(g as AcyclicGraph)
				: exportHeredityDataset(g as AcyclicGraph);
			const bytes:ByteArray = new ByteArray();
			bytes.writeObject(dataset);
			return bytes;
		}
		protected function getTaxonIdentifierForVertex(v:Object):TaxonIdentifier
		{
			if (v is TaxonIdentifier)
				return v as TaxonIdentifier;
			if (vertexMap[v] is TaxonIdentifier)
				return vertexMap[v] as TaxonIdentifier;
			const identifier:TaxonIdentifier = new TaxonIdentifier();
			identifier.entity = new Taxon();
			if (definitionFactory)
				identifier.entity.definition = definitionFactory.newInstance() as Definition;
			if (v is String)
			{
				identifier.label.name = v as String;
				identifier.label.italics = true;
				identifier.localName = localNamePrefix + escape(v as String);
			}
			else
			{
				identifier.label.name = "";
				identifier.localName = localNamePrefix + "innom:" + (unnamedIndex++);
			}
			vertexMap[v] = identifier;
			return identifier;
		}
		public function exportHeredityDataset(g:AcyclicGraph):Dataset
		{
			const dataset:Dataset = new Dataset();
			unnamedIndex = 0;
			if (vertexMap == null)
				vertexMap = new Dictionary();
			try
			{
				for each (var arc:FiniteList in g.edges)
				{
					var heredity:Heredity = new Heredity();
					heredity.predecessor = getTaxonIdentifierForVertex(arc.getMember(0));
					heredity.successor = getTaxonIdentifierForVertex(arc.getMember(1));
					if (arc.size >= 3 && arc.getMember(2) is Number)
						heredity.weight = arc.getMember(2) as Number;
					dataset.heredities.addItem(heredity);
				}
			}
			catch (e:Error)
			{
				throw e;
			}
			return dataset;
		}
		public function exportInclusionDataset(g:AcyclicGraph):Dataset
		{
			const dataset:Dataset = new Dataset();
			unnamedIndex = 0;
			vertexMap = new Dictionary();
			try
			{
				for each (var arc:FiniteList in g.edges)
				{
					var inclusion:Inclusion = new Inclusion();
					inclusion.superset = getTaxonIdentifierForVertex(arc.getMember(0));
					inclusion.subset = getTaxonIdentifierForVertex(arc.getMember(1));
					dataset.inclusions.addItem(inclusion);
				}
			}
			catch (e:Error)
			{
				throw e;
			}
			finally
			{
				vertexMap = null;
			}
			return dataset;
		}
	}
}