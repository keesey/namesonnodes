package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.strings.clean;
	import a3lbmonkeybrain.calculia.collections.graphs.AcyclicGraph;
	import a3lbmonkeybrain.calculia.collections.graphs.importers.NewickImporter;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.math.graphs.DatasetGraphExporter;
	import org.namesonnodes.math.graphs.DatasetGraphImporter;

	public final class TreesBlock extends AbstractNexusBlock
	{
		private var rooted:Boolean = true;
		private var taxaBlocks:Vector.<TaxaBlock>;
		private var translateMap:Dictionary;
		public function TreesBlock(taxaBlocks:Vector.<TaxaBlock>, localName:String)
		{
			super(localName);
			this.taxaBlocks = taxaBlocks.concat();
		}
		private function createTranslateMap():void
		{
			translateMap = new Dictionary();
			for each (var taxaBlock:TaxaBlock in taxaBlocks)
			{
				var i:uint = 0;
				for each (var taxonIdentifier:TaxonIdentifier in taxaBlock.taxa.identifiers)
					translateMap[String(i++)] = taxonIdentifier;
				for each (taxonIdentifier in taxaBlock.taxa.identifiers)
					translateMap[unescape(taxonIdentifier.localName.substr(taxaBlock.localName.length + 1))]
						= taxonIdentifier;
			}	
		}
		private function equateAncestors():void
		{
			const nGraphs:uint = datasets.length;
			if (nGraphs <= 1)
				return;
			const graphs:Vector.<AcyclicGraph> = new Vector.<AcyclicGraph>();
			const importer:DatasetGraphImporter = new DatasetGraphImporter();
			for each (var dataset:Dataset in datasets)
				graphs.push(importer.importHeredityGraph(dataset));
			for (var i:uint = 0; i < nGraphs - 1; ++i)
			{
				var g1:AcyclicGraph = graphs[i];
				var ancestors1:FiniteSet = g1.vertices.diff(g1.maximal(g1.vertices)) as FiniteSet;
				for (var j:uint = i + 1; j < nGraphs; ++j)
				{
					var g2:AcyclicGraph = graphs[j];
					var ancestors2:FiniteSet = g2.vertices.diff(g2.maximal(g2.vertices)) as FiniteSet;
					for each (var vertex1:TaxonIdentifier in ancestors1)
					{
						var maxSucc1:FiniteSet = g1.maximal(g1.successors(vertex1));
						for each (var vertex2:TaxonIdentifier in ancestors2)
						{
							if (vertex1.entity == vertex2.entity)
								continue;
							var maxSucc2:FiniteSet = g2.maximal(g2.successors(vertex2));
							if (maxSucc1.equals(maxSucc2))
								vertex2.entity = vertex1.entity;
						}
					}
				}
			}
		}
		protected function getOrCreateTranslation(label:String):TaxonIdentifier
		{
			const r:* = translateMap[label];
			if (r is TaxonIdentifier)
				return r as TaxonIdentifier;
			const ti:TaxonIdentifier = new TaxonIdentifier();
			ti.entity = new Taxon();
			ti.label.name = clean(label.replace(/_+/g, " "));;
			ti.label.italics = true;
			ti.localName = localName + ":" + escape(label);
			translateMap[label] = ti;
			return ti;
		}
		override protected function handleComment(comment:String) : void
		{
			if (comment.length == 2)
			{
				if (comment == "&U")
					rooted = false;
				else if (comment == "&R")
					rooted = true;
			}
		}
		override public function parse(bytes:ByteArray) : void
		{
			var command:String;
			do
			{
				var line:Vector.<String> = getLine(bytes);
				command = line[0].toUpperCase();
				switch (command)
				{
					case "END" :
					case "UTREE" :
					{
						break;
					}
					case "TRANSLATE" :
					{
						if (rooted)
						{
							line.shift();
							parseTranslate(line);
						}
						break;
					}
					case "TREE" :
					{
						if (rooted)
						{
							line.shift();
							parseTree(line);
						}
						break;
					}
					case "TITLE" :
					{
						line.shift();
						_title = line.join(" ");
						break;
					}
					case "LINK" :
					{
						line.shift();
						parseLink(line);
						break;
					}
					default :
					{
						trace("[WARNING]", "Unrecognized TREES command: " + command);
					}
				}	
			}
			while (command != "END");
			equateAncestors();
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
		protected function parseTranslate(line:Vector.<String>):void
		{
			createTranslateMap();
			const newTranslateMap:Dictionary = new Dictionary();
			while (line.length != 0)
			{
				var s:String;
				var alias:String = line.shift();
				var original:String;
				if (/=$/.test(alias))
				{
					alias = alias.substr(0, alias.length - 1);
					original = line.shift();
				}
				else if (/=/.test(alias))
				{
					var split:Array = alias.split("=", 2);
					alias = split[0];
					original = split[1];
				}
				else
				{
					original = line.shift();
					if (original == "=")
						original = line.shift();
					else if (/^=/.test(original))
						original = original.substr(1);
				}
				if (alias.length == 0)
					throw new BioFileError("Expected taxon alias in TRANSLATE command.");
				if (/\,$/.test(original))
					original = original.substr(0, original.length - 1);
				else if (line.length != 0 && (s = line.shift()) != ",")
					throw new BioFileError("Expected comma in TRANSLATE command; found <" + s + ">.");
				if (/^'.+'$/.test(original))
					original = original.substr(1, original.length - 2);
				if (original.length == 0)
					throw new BioFileError("Expected taxon label in TRANSLATE command.");
				newTranslateMap[alias] = getOrCreateTranslation(original);
			}
			translateMap = newTranslateMap;
		}
		protected function parseTree(line:Vector.<String>):void
		{
			if (translateMap == null)
				createTranslateMap();
			var name:String = line.shift();
			if (name == "*")
				name = line.shift();
			var tree:String;
			if (/=$/.test(name))
			{
				name = name.substr(0, name.length - 1);
				tree = line.join(" ");
			}
			else if (/=/.test(name))
			{
				var split:Array = name.split("=", 2);
				name = split[0];
				tree = split[1]
			}
			else
			{
				if (line.shift() != "=")
					throw new BioFileError("Missing equals sign (=) in TREE command.");
				tree = line.join(" ");
			}
			if (/^'.+'$/.test(name))
				name = name.substr(1, name.length - 2);
			const importer:NewickImporter = new NewickImporter();
			const treeLocalName:String = localName + ":" + escape(name);
			const exporter:DatasetGraphExporter = new DatasetGraphExporter(treeLocalName, null);
			exporter.vertexMap = translateMap;
			const bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(tree);
			const graph:AcyclicGraph = importer.importGraph(bytes) as AcyclicGraph;
			const dataset:Dataset = exporter.exportHeredityDataset(graph);
			dataset.label.name = clean(name.replace(/_+/g, " "));
			dataset.localName = treeLocalName;
			datasets.push(dataset);
		}
	}
}