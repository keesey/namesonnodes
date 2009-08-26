package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import flash.utils.ByteArray;
	
	import mx.core.IFactory;
	
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Definition;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class TaxaBlock extends AbstractNexusBlock
	{
		private const dataset:Dataset = new Dataset();
		public function TaxaBlock(localName:String = "TAXA")
		{
			super(localName);
			dataset.localName = localName;
			dataset.label.name = "Taxa";
			datasets.push(dataset);
		}
		public function addTaxonIdentifier(name:String, index:uint):TaxonIdentifier
		{
			const ti:TaxonIdentifier = new TaxonIdentifier();
			ti.entity = new Taxon();
			ti.label.name = clean(name.replace(/_+/g, " "));;
			ti.label.italics = true;
			ti.localName = localName + ":" + escape(name);
			taxa.setByIndex(index, ti);
			return ti;
		}
		public function getTaxonIdentifierByLabel(label:String):TaxonIdentifier
		{
			return taxa.getByLocalName(dataset.localName + ":" + escape(label));
		}
		override public function parse(bytes:ByteArray) : void
		{
			var line:Vector.<String> = getLine(bytes);
			if (line[0].toUpperCase() == "TITLE")
			{
				line.shift();
				dataset.label.name = _title = line.join(" ");
				line = getLine(bytes);
			}
			if (line[0].toUpperCase() == "DIMENSIONS")
			{
				parseDimensions(line);
				line = getLine(bytes);
			}
			if (line[0].toUpperCase() != "TAXLABELS")
				throw new BioFileError("Expected TAXLABELS command; found: " + line.join(" ") + ";");
			line.shift();
			parseTaxLabels(line);
			do
			{
				line = getLine(bytes);
				var firstWord:String = line[0].toUpperCase();
			}
			while (firstWord != "END" && firstWord != "ENDBLOCK");
		}
		protected function parseDimensions(line:Vector.<String>):void
		{
			line.shift();
			line = Vector.<String>(line.join(" ").replace(/\s*=\s*/g, "=").split(" "));
			const n:uint = line.length;
			for each (var word:String in line)
			{
				word = word.toUpperCase();
				if (/^NTAX=\d+$/.test(word))
					taxa.number = parseInt(word.split("=")[1]);
				else if (word == "NEWTAXA")
					/* Do nothing; */;
				else
					trace("[WARNING]", "Unknown DIMENSIONS attribute:", word);
			}
		}
		internal function parseTaxLabels(line:Vector.<String>):void
		{
			for each (var label:String in line)
			{
				var identifier:TaxonIdentifier = new TaxonIdentifier();
				identifier.localName = dataset.localName + ":" + escape(label);
				identifier.label.italics = true;
				identifier.label.name = clean(label.replace(/_+/g, " "));
				identifier.entity = new Taxon();
				taxa.add(identifier);
			}
		}
	}
}