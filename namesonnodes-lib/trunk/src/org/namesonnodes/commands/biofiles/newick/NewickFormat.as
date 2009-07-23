package org.namesonnodes.commands.biofiles.newick
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	import a3lbmonkeybrain.calculia.collections.graphs.AcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.importers.NewickImporter;
	
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.namesonnodes.commands.biofiles.AbstractBioFileFormat;
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.math.graphs.DatasetGraphExporter;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class NewickFormat extends AbstractBioFileFormat
	{
		private static const FILTER:FileFilter = new FileFilter("Newick Tree Files",
			"*.newick;*.new;*.tree;*.tre");
		private const exporter:DatasetGraphExporter = new DatasetGraphExporter("taxon:", null);
		private const importer:NewickImporter = new NewickImporter();
		public function NewickFormat()
		{
			super();
		}
		override public function get filter():FileFilter
		{
			return FILTER;
		}
		override public function get flowName():String
		{
			return "Upload Newick Tree.";
		}
		override public function matches(input:Object):Boolean
		{
			const bytes:ByteArray = interpretAsBytes(input);
			if (bytes == null || bytes.length < 2)
				return false;
			return importer.matches(bytes);
		}
		override protected function parseBytes(bytes:ByteArray):void
		{
			try
			{
				const g:AcyclicGraph = importer.importGraph(bytes) as AcyclicGraph;
				const dataset:Dataset = exporter.exportHeredityDataset(g);
				dataset.localName = "tree";
				dataset.label.name = "Tree";
				result.datasets.push(dataset);
			}
			catch (e:Error)
			{
				handleError(e);
				return;
			}
			deferResult();
		}
	}
}