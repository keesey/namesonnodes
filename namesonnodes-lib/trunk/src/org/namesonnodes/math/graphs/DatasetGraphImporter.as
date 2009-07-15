package org.namesonnodes.math.graphs
{
	import a3lbmonkeybrain.calculia.collections.graphs.AcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.Graph;
	import a3lbmonkeybrain.calculia.collections.graphs.HashNetwork;
	import a3lbmonkeybrain.calculia.collections.graphs.importers.GraphImporter;
	
	import flash.utils.ByteArray;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;

	public final class DatasetGraphImporter implements GraphImporter
	{
		private var _inclusionMode:Boolean = false;
		public function DatasetGraphImporter()
		{
			super();
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
		public function importGraph(bytes:ByteArray):Graph
		{
			bytes.position = 0;
			const o:* = bytes.readObject();
			if (!(o is Dataset))
				throw new ArgumentError("Not a dataset.");
			return _inclusionMode
				? importInclusionGraph(o as Dataset)
				: importHeredityGraph(o as Dataset);
		}
		public function importHeredityGraph(d:Dataset):AcyclicGraph
		{
			const g:HashNetwork = new HashNetwork();
			for each (var heredity:Heredity in d.heredities)
				if (!isNaN(heredity.weight) && heredity.weight != 0.0)
					g.createEdge(heredity.predecessor, heredity.successor);
				else
					g.createWeightedEdge(heredity.predecessor, heredity.successor, heredity.weight);
			return g;
		}
		public function importInclusionGraph(d:Dataset):AcyclicGraph
		{
			const g:HashNetwork = new HashNetwork();
			for each (var inclusion:Inclusion in d.inclusions)
				g.createEdge(inclusion.superset, inclusion.subset);
			return g;
		}
		public function matches(bytes:ByteArray):Boolean
		{
			if (bytes == null || bytes.length == 0)
				return false;
			bytes.position = 0;
			try
			{
				const o:* = bytes.readObject();
				return o is Dataset;
			}
			catch (e:Error)
			{
			}
			return false;
		}
	}
}