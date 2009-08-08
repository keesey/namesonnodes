package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.DistanceRow;
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.utils.parseQName;

	internal final class DatasetReader implements EntityReader
	{
		private var authorityIdentifierReader:EntityReader;
		private var factory:EntityFactory;
		private var taxonIdentifierReader:EntityReader;
		public function DatasetReader(factory:EntityFactory, authorityIdentifierReader:EntityReader, taxonIdentifierReader:EntityReader)
		{
			super();
			this.factory = factory;
			this.authorityIdentifierReader = authorityIdentifierReader;
			this.taxonIdentifierReader = taxonIdentifierReader;
		}
		public function readEntity(source:XML):Persistent
		{
			default xml namespace = Entities.URI;
			const dataset:Dataset = new Dataset();
			readPersistent(source, dataset);
			readQualified(source, dataset, factory.references, authorityIdentifierReader);
			if (source.weightPerGeneration.length() == 1)
				dataset.weightPerGeneration = parseFloat(source.weightPerGeneration);
			readDistanceRows(source, dataset);
			readHeredities(source, dataset);
			readInclusions(source, dataset);
			readSynonymies(source, dataset);
			factory.dictionary[dataset.qName.toString()] = dataset;
			return dataset;
		}
		private function readHeredities(source:XML, dataset:Dataset):void
		{
			// :TODO:
		}
		private function readInclusions(source:XML, dataset:Dataset):void
		{
			// :TODO:
		}
		private function readSynonymies(source:XML, dataset:Dataset):void
		{
			// :TODO:
		}
		private function readDistanceRows(source:XML, dataset:Dataset):void
		{
			if (source.distanceRows.length() != 1)
				return;
			for each (var rowSource:XML in source.distanceRows.DistanceRow)
				dataset.distanceRows.addItem(readDistanceRow(rowSource));
		}
		private function readDistanceRow(source:XML):DistanceRow
		{
			const row:DistanceRow = new DistanceRow();
			readPersistent(source, row);
			if (source.a.length() != 1 || source.b.length() != 1)
				throw new ArgumentError("Operand missing in distance row.");
			if (source.distance.length() != 1)
				throw new ArgumentError("Distance missing in distance row.");
			if (source.a.TaxonIdentifier.length() == 1)
				row.a = taxonIdentifierReader.readEntity(source.a[0]) as TaxonIdentifier;
			else if (source.a.refTaxon.length() == 1)
				factory.references.push(new TaxonReference(parseQName(source.a.refTaxon.text()), row, "a"));
			else
				throw new ArgumentError("Invalid operand A.");
			if (source.b.TaxonIdentifier.length() == 1)
				row.b = taxonIdentifierReader.readEntity(source.b[0]) as TaxonIdentifier;
			else if (source.b.refTaxon.length() == 1)
				factory.references.push(new TaxonReference(parseQName(source.a.refTaxon.text()), row, "b"));
			else
				throw new ArgumentError("Invalid operand B.");
			row.distance = parseFloat(source.distance);
			return row;
		}
	}
}