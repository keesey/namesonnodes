package org.namesonnodes.commands.biofiles.nexus
{
	import flash.utils.ByteArray;
	
	import mx.core.ClassFactory;
	
	import org.namesonnodes.domain.entities.Dataset;

	public final class DataBlock implements NexusBlock
	{
		private var charactersBlock:CharactersBlock;
		private var _taxaBlock:TaxaBlock = new TaxaBlock();
		private var localName:String;
		public function DataBlock(localName:String = "DATA")
		{
			super();
			this.localName = localName;
			_taxaBlock = new TaxaBlock(localName + ":TAXA");
			charactersBlock = new CharactersBlock(Vector.<TaxaBlock>([taxaBlock]),
				localName + ":CHARACTERS");
		}

		public function get taxaBlock():TaxaBlock
		{
			return _taxaBlock;
		}

		public function get title():String
		{
			return charactersBlock.title;
		}
		public function get datasets():Vector.<Dataset>
		{
			const datasets:Vector.<Dataset> = new Vector.<Dataset>();
			for each (var charDataset:Dataset in charactersBlock.datasets)
			{
				var dataset:Dataset = new Dataset();
				dataset.label.name = "Data";
				dataset.localName = localName;
				dataset.heredities.addAll(charDataset.heredities);
				dataset.inclusions.addAll(charDataset.inclusions);
				dataset.synonymies.addAll(charDataset.synonymies);
				datasets.push(dataset);
			}
			return datasets;
		}
		public function get taxa():TaxonIdentifierLibrary
		{
			return taxaBlock.taxa;
		}
		public function parse(bytes:ByteArray):void
		{
			charactersBlock.parse(bytes);
		}
	}
}