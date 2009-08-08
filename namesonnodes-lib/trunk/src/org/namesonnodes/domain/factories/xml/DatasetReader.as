package org.namesonnodes.domain.factories.xml
{
	import a3lbmonkeybrain.brainstem.w3c.xml.XMLNodeKind;
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.DistanceRow;
	import org.namesonnodes.domain.entities.Entities;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.Synonymy;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.entities.non_entities;
	import org.namesonnodes.utils.parseQName;

	use namespace non_entities;

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
			readQualified(source, dataset, null, factory.authorityReferences, authorityIdentifierReader);
			if (source.weightPerGeneration.length() == 1)
				dataset.weightPerGeneration = parseFloat(source.weightPerGeneration);
			readDistanceRows(source, dataset);
			readHeredities(source, dataset);
			readInclusions(source, dataset);
			readSynonymies(source, dataset);
			return dataset;
		}
		private function readHeredities(source:XML, dataset:Dataset):void
		{
			default xml namespace = Entities.URI;
			if (source.heredities.length() != 1)
				return;
			for each (var hereditySource:XML in source.heredities.Heredity)
				dataset.heredities.addItem(readHeredity(hereditySource));
		}
		private function readHeredity(source:XML):Heredity
		{
			default xml namespace = Entities.URI;
			const heredity:Heredity = new Heredity();
			readPersistent(source, heredity);
			if (source.weight.length() == 1)
				heredity.weight = parseFloat(source.weight.text());
			readTaxonIdentifier(source.predecessor, heredity, "predecessor");
			readTaxonIdentifier(source.successor, heredity, "successor");
			return heredity;
		}
		private function readInclusion(source:XML):Inclusion
		{
			default xml namespace = Entities.URI;
			const inclusion:Inclusion = new Inclusion();
			readPersistent(source, inclusion);
			readTaxonIdentifier(source.superset, inclusion, "superset");
			readTaxonIdentifier(source.subset, inclusion, "subset");
			return inclusion;
		}
		private function readSynonymy(source:XML):Synonymy
		{
			default xml namespace = Entities.URI;
			const synonymy:Synonymy = new Synonymy();
			readPersistent(source, synonymy);
			if (source.synonyms.length() != 1)
				throw new ArgumentError("Invalid synonymy.");
			if (source.synonyms.children().length() < 2)
				throw new ArgumentError("Invalid number of synonyms.");
			for each (var synonymSource:XML in source.synonyms.children())
			{
				if (synonymSource.nodeKind() != XMLNodeKind.ELEMENT)
					continue;
				if (synonymSource.name().uri != Entities.URI)
					throw new ArgumentError("Unrecognized namespace: <" + synonymSource.name().uri + ">.");
				if (synonymSource.localName() == "TaxonIdentifier")
					synonymy.synonyms.addItem(taxonIdentifierReader.readEntity(synonymSource));
				else if (synonymSource.localName() == "refTaxon")
				{
					factory.taxonReferences.push(new TaxonReference(parseQName(synonymSource.text()), synonymy.synonyms, synonymy.synonyms.length));
					synonymy.synonyms.addItem(null);
				}
				else
					throw new ArgumentError("Unrecognized element: <" + synonymSource.name() + ">.");
			}
			return synonymy;
		}
		private function readInclusions(source:XML, dataset:Dataset):void
		{
			default xml namespace = Entities.URI;
			if (source.inclusions.length() != 1)
				return;
			for each (var inclusionSource:XML in source.inclusions.Inclusion)
				dataset.inclusions.addItem(readInclusion(inclusionSource));
		}
		private function readSynonymies(source:XML, dataset:Dataset):void
		{
			default xml namespace = Entities.URI;
			if (source.synonymies.length() != 1)
				return;
			for each (var synonymySource:XML in source.synonymies.Synonymy)
				dataset.synonymies.addItem(readSynonymy(synonymySource));
		}
		private function readDistanceRows(source:XML, dataset:Dataset):void
		{
			default xml namespace = Entities.URI;
			if (source.distanceRows.length() != 1)
				return;
			for each (var rowSource:XML in source.distanceRows.DistanceRow)
				dataset.distanceRows.addItem(readDistanceRow(rowSource));
		}
		private function readTaxonIdentifier(source:XMLList, target:Object, property:String, name:String = null):void
		{
			default xml namespace = Entities.URI;
			if (name == null)
				name = property;
			if (source == null || source.length() == 0)
				throw new ArgumentError("No " + name + ".");
			if (source.length() != 1)
				throw new ArgumentError("Invalid specification of " + name + ".");
			if (source.TaxonIdentifier.length() == 1)
				target[property] = taxonIdentifierReader.readEntity(source.TaxonIdentifier[0]) as TaxonIdentifier;
			else if (source.refTaxon.length() == 1)
				factory.taxonReferences.push(new TaxonReference(parseQName(source.refTaxon[0].text()), target, property));
			else
				throw new ArgumentError("Invalid " + name + ".");
		}
		private function readDistanceRow(source:XML):DistanceRow
		{
			default xml namespace = Entities.URI;
			const row:DistanceRow = new DistanceRow();
			readPersistent(source, row);
			readTaxonIdentifier(source.a, row, "a", "operand A");
			readTaxonIdentifier(source.b, row, "b", "operand B");
			if (source.distance.length() != 1)
				throw new ArgumentError("Distance missing in distance row.");
			row.distance = parseFloat(source.distance);
			return row;
		}
	}
}