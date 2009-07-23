package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Inclusion;
	import org.namesonnodes.domain.entities.StateDefinition;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class CharactersBlock extends AbstractNexusBlock
	{
		private const dataset:Dataset = new Dataset();
		private const format:CharactersFormat = new CharactersFormat();
		private const charLabels:Vector.<String> = new Vector.<String>();
		private var charStateIdentifiers:Vector.<Vector.<TaxonIdentifier>>;
		private var taxaBlocks:Vector.<TaxaBlock>;
		public function CharactersBlock(taxaBlocks:Vector.<TaxaBlock>, localName:String = "CHARACTERS")
		{
			super(localName);
			this.taxaBlocks = taxaBlocks.concat();
			dataset.label.name = "Characters";
			_datasets.push(dataset);
		}
		private function clear():void
		{
			with (dataset)
			{
				heredities.removeAll();
				inclusions.removeAll();
				synonymies.removeAll();
			}
			taxa.clear();
		}
		private function getStateIdentifier(charIndex:uint, stateIndex:uint,
			charLabel:String = null, stateLabel:String = null):TaxonIdentifier
		{
			while (charStateIdentifiers.length <= charIndex)
				charStateIdentifiers.push(new Vector.<TaxonIdentifier>());
			var states:Vector.<TaxonIdentifier> = charStateIdentifiers[charIndex];
			if (states == null)
			{
				states = new Vector.<TaxonIdentifier>();
				charStateIdentifiers[charIndex] = states;
			}
			while (states.length <= stateIndex)
				states.push(null);
			var state:TaxonIdentifier = states[stateIndex];
			if (state == null)
			{
				state = new TaxonIdentifier();
				state.entity = new Taxon();
				state.entity.definition = new StateDefinition();
				state.label.name = (charLabel ? charLabel : ("Character #" + (charIndex + 1)))
					+ ": " + (stateLabel ? stateLabel : ("State #" + stateIndex));
				state.localName = localName + ":" + charIndex + ":" + stateIndex;
				states[stateIndex] = state;
				taxa.add(state);
			}
			return state;
		}
		override public function parse(bytes:ByteArray):void
		{
			clear();
			var command:String;
			do
			{
				var line:Vector.<String> = getLine(bytes);
				command = line[0].toUpperCase();
				switch (command)
				{
					case "END" :
					case "ELIMINATE" :
					case "OPTIONS" :
					{
						break;
					}
					case "TITLE" :
					{
						line.shift();
						dataset.label.name = _title = line.join(" ");
						break;
					}
					case "LINK" :
					{
						line.shift();
						parseLink(line);
						break;
					}
					case "DIMENSIONS" :
					{
						parseDimensions(line);
						break;
					}
					case "FORMAT" :
					{
						format.parse(line);
						break;
					}
					case "TAXLABELS" :
					{
						line.shift();
						for each (var taxaBlock:TaxaBlock in taxaBlocks)
							taxaBlock.parseTaxLabels(line);
						break;
					}
					case "CHARSTATELABELS" :
					{
						line.shift();
						parseCharStateLabels(line);
						break;
					}
					case "CHARLABELS" :
					{
						line.shift();
						parseCharLabels(line);
						break;
					}
					case "STATELABELS" :
					{
						line.shift();
						parseStateLabels(line);
						break;
					}
					case "MATRIX" :
					{
						line.shift();
						parseMatrix(line);
						break;
					}
					default :
					{
						trace("[WARNING]", "Unknown CHARACTERS command: " + command);
					}
				}
			}
			while (command != "END");
		}
		protected function parseCharLabels(line:Vector.<String>):void
		{
			if (format.dataType != CharactersFormat.DATATYPE_STANDARD)
				return;
			for each (var label:String in line)
				charLabels.push(label);
		}
		protected function parseCharStateLabels(line:Vector.<String>):void
		{
			if (format.dataType != CharactersFormat.DATATYPE_STANDARD)
				return;
			charStateIdentifiers = new Vector.<Vector.<TaxonIdentifier>>(taxa.number);
			line = Vector.<String>(line.join(" ").split(/\s*,\s*/g));
			const n:uint = line.length;
			for each (var item:String in line)
			{
				var halves:Array = item.split(/\s*\/\s*/g, 2);
				if (halves.length == 0)
					throw new BioFileError("Invalid CHARSTATELABELS item: " + item);
				var ids:Array = String(halves[0]).match(/^(\d+)(\s+.+)?$/);
				if (ids == null || ids.length < 2)
					throw new BioFileError("Invalid CHARSTATELABELS item: " + item);
				var charIndex:uint = parseInt(ids[1]);
				var charLabel:String = ids.length == 3 ? clean(ids[2] as String) : null;
				if (charLabel && charLabel.match(/^'.+'$/))
					charLabel = charLabel.substr(0, charLabel.length - 2);
				var states:Vector.<String>;
				if (halves.length == 2)
					states = Vector.<String>(String(halves[1]).split(/\s+/g));
				else
					states = format.symbols;
				var stateIndex:uint = 0;
				for each (var state:String in states)
					getStateIdentifier(charIndex, stateIndex++, charLabel, state);
			}
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
				{
					var nTax:uint = parseInt(word.split("=", 2)[1]);
					for each (var taxaBlock:TaxaBlock in taxaBlocks)
						taxaBlock.taxa.number = nTax;
				}
				else if (/^NCHAR=\d+$/.test(word))
				{
					taxa.number = parseInt(word.split("=", 2)[1]);
					charStateIdentifiers = new Vector.<Vector.<TaxonIdentifier>>(taxa.number);
				}
				else if (word == "NEWTAXA")
					/* Do nothing; */;
				else
					trace("[WARNING]", "Unknown DIMENSIONS attribute:", word);
			}
		}
		protected function parseLink(line:Vector.<String>):void
		{
			line = Vector.<String>(line.join(" ").replace(/\s+/, " ").split(/\s*=\s*/g));
			if (line.length == 2 && line[0].toUpperCase() == "TAXA")
			{
				var title:String = line[1];
				var newBlocks:Vector.<TaxaBlock> = new Vector.<TaxaBlock>();
				for each (var block:TaxaBlock in taxaBlocks)
					if (block.title == title)
						newBlocks.push(block);
				taxaBlocks = newBlocks;
			}
		}
		protected function parseMatrix(line:Vector.<String>):void
		{
			if (format.dataType != CharactersFormat.DATATYPE_STANDARD)
				return;
			const currentColumns:Dictionary = new Dictionary();
			var rowIndex:uint = 0;
			while (line.length > 0)
			{
				var rowName:String = line.shift();
				if (/^\'.+\'$/.test(rowName))
					rowName = rowName.substr(1, rowName.length - 2);
				var row:String = line.shift();
				if (currentColumns[rowName] == undefined)
					currentColumns[rowName] = uint(0);
				var n:uint = row.length;
				var taxonIdentifier:TaxonIdentifier;
				if (!format.transpose)
				{
					for each (var taxaBlock:TaxaBlock in taxaBlocks)
					{
						taxonIdentifier = taxaBlock.getTaxonIdentifierByLabel(rowName);
						if (taxonIdentifier is TaxonIdentifier)
							break;
					}
					if (taxonIdentifier == null)
					{
						for each (taxaBlock in taxaBlocks)
						{
							taxonIdentifier = taxaBlock.taxa.getByIndex(rowIndex % taxaBlock.taxa.number);
							if (taxonIdentifier is TaxonIdentifier)
								break;
						}
					}
					if (taxonIdentifier == null)
						taxonIdentifier = taxaBlocks[0].addTaxonIdentifier(rowName,
							rowIndex % taxaBlocks[0].taxa.number);
				}
				for (var i:uint = 0; i < n; ++i)
				{
					var c:String = row.charAt(i);
					if (c == "(")
					{
						c = "";
						do
						{
							var c2:String = row.charAt(++i);
							if (c2 == ")")
								break;
							c += c2;
						} while (i < n);
					}
					var stateIndices:Vector.<uint> = format.getStateIndices(c);
					if (stateIndices.length != 0)
					{
						var charIndex:uint;
						if (format.transpose)
						{
							charIndex = charLabels.indexOf(rowName);
							if (charIndex < 0)
							 	throw new BioFileError("Cannot find character labeled <" + rowName + ">.");
							 if (taxaBlocks.length == 0)
							 	throw new BioFileError("No TAXA block associated with this CHARACTERS block.");
							taxonIdentifier = taxaBlocks[0].taxa.getByIndex(currentColumns[rowName]);
							if (taxonIdentifier == null)
								throw new BioFileError("No taxon for column #" + currentColumns[rowName])
						}
						else
							charIndex = currentColumns[rowName];
						if (charIndex >= charStateIdentifiers.length)
							throw new BioFileError("Invalid character index: " + charIndex);
						for each (var stateIndex:uint in stateIndices)
						{
							var stateIdentifier:TaxonIdentifier
								= getStateIdentifier(charIndex, stateIndex);
							var inclusion:Inclusion = new Inclusion();
							inclusion.superset = stateIdentifier;
							inclusion.subset = taxonIdentifier;
							dataset.inclusions.addItem(inclusion);
						}
					}
					currentColumns[rowName]++;
				}
				rowIndex++;
			}
		}
		protected function parseStateLabels(line:Vector.<String>):void
		{
			if (format.dataType != CharactersFormat.DATATYPE_STANDARD)
				return;
			while (line.length > 0)
			{
				var charIndex:uint = parseInt(line.shift()) - 1;
				var stateIndex:uint = parseInt(line.shift());
				var stateLabel:String = line.shift();
				var charLabel:String = charLabels[charIndex];
				getStateIdentifier(charIndex, stateIndex, charLabel, stateLabel);
			}
		}
	}
}