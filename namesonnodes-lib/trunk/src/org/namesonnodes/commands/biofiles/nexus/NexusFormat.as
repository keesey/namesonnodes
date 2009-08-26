package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.biofiles.AbstractBioFileFormat;
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.Dataset;

	public final class NexusFormat extends AbstractBioFileFormat
	{
		public static const FILTER:FileFilter = new FileFilter("NEXUS Files", "*.nexus;*.nex;*.nx;*.tree;*.tre");
		private static const HEADER:String = "#NEXUS";
		private static const HEADER_LENGTH:uint = 6;
		private var blockFactory:NexusBlockFactory;
		private var bytes:ByteArray;
		public function NexusFormat()
		{
			super();
		}
		override public function get filter():FileFilter
		{
			return FILTER;
		}
		override public function get flowName():String
		{
			return "Upload a NEXUS file.";
		}
		private function getCharSkipComment(bytes:ByteArray):String
		{
			var c:String = getChar(bytes);
			var comment:String = "";
			while (c == "[")
			{
				do
				{
					c = getChar(bytes);
					comment += c;
				}
				while (c != "]");
				result.comments += clean(comment.substr(0, comment.length - 1)) + "\n";
				c = getChar(bytes);
			}
			return c;
		}
		override protected function handleError(e:Error) : void
		{
			blockFactory = null;
			super.handleError(e);
		}
		override public function matches(input:Object):Boolean
		{
			const bytes:ByteArray = interpretAsBytes(input);
			if (bytes == null)
				return false;
			if (bytes.length < HEADER_LENGTH)
				return false;
			bytes.position = 0;
			const s:String = getChar(bytes, HEADER_LENGTH);
			return s.toUpperCase() == HEADER;
		}
		override protected function parseBytes(bytes:ByteArray):void
		{
			blockFactory = null;
			parseHeader(bytes);
			blockFactory = new NexusBlockFactory();
			this.bytes = bytes;
			parseNextBlock();
		}
		protected function parseHeader(bytes:ByteArray):void
		{
			const s:String = getChar(bytes, HEADER_LENGTH);
			if (s.toUpperCase() != HEADER)
				throw new BioFileError("This does not appear to be a NEXUS file.");
		}
		protected function parseNextBlock():void
		{
			const timer:Timer = new Timer(32, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onBlockTimerComplete);
			timer.start();
			dispatchProgress(bytes);
		}
		protected function onBlockTimerComplete(event:TimerEvent):void
		{
			try
			{
				IEventDispatcher(event.target).removeEventListener(event.type,
					onBlockTimerComplete);
				if (bytes.bytesAvailable == 0)
				{
					blockFactory = null;
					dispatchEvent(ResultEvent.createEvent(result));
				}
				else
				{
					skipWhitespaceAndComments(bytes);
					const block:NexusBlock = blockFactory.createBlock(bytes);
					trace("[NOTICE]", "Parsed block:", block);
					if (block && block.datasets)
						for each (var dataset:Dataset in block.datasets)
							if (dataset && dataset.hasRelations())
								result.datasets.push(dataset);
					skipWhitespaceAndComments(bytes);
					parseNextBlock();
				}
			}
			catch (e:Error)
			{
				trace("[ERROR]", e.getStackTrace());
				handleError(e);
			}
		}
		protected function skipWhitespaceAndComments(bytes:ByteArray):void
		{
			var c:String;
			do
			{
				if (bytes.bytesAvailable == 0)
					return;
				c = getCharSkipComment(bytes);
			}
			while (/\s/.test(c));
			bytes.position--;
		}
	}
}