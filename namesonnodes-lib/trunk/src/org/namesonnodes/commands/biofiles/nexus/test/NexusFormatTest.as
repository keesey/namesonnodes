package org.namesonnodes.commands.biofiles.nexus.test
{
	import a3lbmonkeybrain.brainstem.assert.assertType;
	import a3lbmonkeybrain.calculia.collections.graphs.exporters.TextCladogramExporter;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import flexunit.framework.AssertionFailedError;
	import flexunit.framework.TestCase;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.biofiles.ParseResult;
	import org.namesonnodes.commands.biofiles.nexus.NexusFormat;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.math.graphs.DatasetGraphImporter;

	public class NexusFormatTest extends TestCase
	{
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/angiosperms.nex",mimeType="application/octet-stream")]
		public static const FILE_ANGIOSPERMS:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/anolesLabdata.nex",mimeType="application/octet-stream")]
		public static const FILE_ANOLES_LAB_DATA:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/Aquilegia.nex",mimeType="application/octet-stream")]
		public static const FILE_AQUILEGIA:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/avian-ovomucoids.nex",mimeType="application/octet-stream")]
		public static const FILE_AVIAN_OVOMUCOIDS:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/Barrett_etal_2007b.nex",mimeType="application/octet-stream")]
		public static const FILE_BARRETT_ETAL_2007B:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/M3455.txt",mimeType="application/octet-stream")]
		public static const FILE_M3455:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/primate-mtDNA.nex",mimeType="application/octet-stream")]
		public static const FILE_PRIMATE_MTDNA:Class;
		[Embed(source="org/namesonnodes/commands/biofiles/nexus/test/primate-mtDNA-interleaved.nex",mimeType="application/octet-stream")]
		public static const FILE_PRIMATE_MTDNA_INTERLEAVED:Class;
		private var invokeFile:ByteArray;
		private var invokeFiles:Vector.<ByteArray>;
		private const importer:DatasetGraphImporter = new DatasetGraphImporter();
		private const exporter:TextCladogramExporter = new TextCladogramExporter();
		public function NexusFormatTest(methodName:String=null)
		{
			super(methodName);
			exporter.vertexLabelFunction = function(v:TaxonIdentifier):String
			{
				const s:String = v.label.name;
				if (s == null)
					return "";
				return s + " <" + v.localName + ">";
			}
		}
		public static function createFiles():Vector.<ByteArray>
		{
			const files:Vector.<ByteArray> = new Vector.<ByteArray>();
			//files.push(new FILE_ANGIOSPERMS() as ByteArray);
			//files.push(new FILE_ANOLES_LAB_DATA() as ByteArray);
			//files.push(new FILE_AQUILEGIA() as ByteArray);
			//files.push(new FILE_AVIAN_OVOMUCOIDS() as ByteArray);
			files.push(new FILE_BARRETT_ETAL_2007B() as ByteArray);
			//files.push(new FILE_M3455() as ByteArray);
			//files.push(new FILE_PRIMATE_MTDNA() as ByteArray);
			//files.push(new FILE_PRIMATE_MTDNA_INTERLEAVED() as ByteArray);
			return files;
		}
		public function testMatches():void
		{
			const format:NexusFormat = new NexusFormat();
			assertFalse(format.matches("#nexus BEGIN DATA; END;"));
			assertFalse(format.matches("#foo"));
			assertFalse(format.matches(""));
			assertFalse(format.matches(null));
			assertFalse(format.matches(new Event("dummy")));
			assertTrue(format.matches("#NEXUS\nBEGIN DATA; END;"));
			assertTrue(format.matches("#NEXUS"));
			for each (var file:ByteArray in createFiles())
			{
				assertTrue(format.matches(file));
				file.clear();
			}
		}
		public function testInvoke():void
		{
			invokeFiles = createFiles();
			invokeNext();
		}
		private function invokeNext():void
		{
			if (invokeFiles.length != 0)
			{
				System.gc();
				const format:NexusFormat = new NexusFormat();
				invokeFile = invokeFiles.pop();
				format.addEventListener(FaultEvent.FAULT, trace);
				format.addEventListener(ResultEvent.RESULT, addAsync(onResult, 60000));
				format.invoke(invokeFile);
			}
		}
		private function onResult(event:ResultEvent):void
		{
			IEventDispatcher(event.target).removeEventListener(event.type, onResult);
			invokeFile.clear();
			invokeFile = null;
			assertType(event.result, ParseResult);
			const result:ParseResult = event.result as ParseResult;
			trace("[NOTICE]", "NEXUS file parsed.");
			trace("[NOTICE]", result.comments);
			trace("[NOTICE]", "Datasets:", result.datasets.length);
			for each (var dataset:Dataset in result.datasets)
			{
				assertTrue(dataset.heredities.length > 0 || dataset.inclusions.length > 0);
				if (dataset.heredities.length > 0)
				{
					trace("[NOTICE]", "Begin heredity network.");
					assertTrue(dataset.inclusions.length == 0);
					traceBytes(exporter.export(importer.importHeredityGraph(dataset)));
					trace("[NOTICE]", "End heredity network.");
				}
				else if (dataset.inclusions.length > 0)
				{
					trace("[NOTICE]", "Begin inclusion network.");
					assertTrue(dataset.heredities.length == 0);
					traceBytes(exporter.export(importer.importInclusionGraph(dataset)));
					trace("[NOTICE]", "End inclusion network.");
				}
				else throw new AssertionFailedError("No inclusions or heredities in dataset.");
			}
			trace("[NOTICE]", "End NEXUS file.");
			invokeNext();
		}
		private static function traceBytes(bytes:ByteArray):void
		{
			bytes.position = 0;
			trace(bytes.readUTFBytes(bytes.length));
		}
	}
}