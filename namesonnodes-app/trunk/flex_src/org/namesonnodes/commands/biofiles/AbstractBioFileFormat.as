package org.namesonnodes.commands.biofiles
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.AbstractCommandFlow;
	
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	public class AbstractBioFileFormat extends AbstractCommandFlow implements BioFileFormat
	{
		protected static const CHAR_SET:String = "us-ascii";
		protected static const UNNAMED:String = "innom.";
		protected var result:ParseResult;
		public function AbstractBioFileFormat()
		{
			super();
		}
		public function get filter():FileFilter
		{
			throw new AbstractMethodError();
		}
		protected final function dispatchProgress(bytes:ByteArray):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytes.position, bytes.length));
		}
		protected final function deferResult(ms:uint = 32):void
		{
			const timer:Timer = new Timer(ms, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onDeferTimerComplete);
			timer.start();	
		}
		protected static function getChar(bytes:ByteArray, length:uint = 1):String
		{
			return bytes.readMultiByte(length, CHAR_SET);
		}
		protected function handleNullInput():void
		{
			throw new ArgumentError("Unreadable file data.");
		}
		protected static function interpretAsBytes(input:Object):ByteArray
		{
			if (input is ByteArray)
				return input as ByteArray;
			else if (input is FileReference)
				return FileReference(input).data;
			else if (input is String)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeMultiByte(input as String, CHAR_SET);
				return bytes;
			}
			return null;
		}
		override public function invoke(input:Object):void
		{
			if (result)
				throw new IllegalOperationError("This command is already in process.");
			result = new ParseResult();
			const bytes:ByteArray = interpretAsBytes(input);
			if (bytes == null)
				handleNullInput();
			dispatchEvent(InvokeEvent.createEvent());
			if (bytes != null)
			{
				bytes.position = 0;
				parseBytes(bytes);
			}
		}
		private function onDeferTimerComplete(event:TimerEvent):void
		{
			IEventDispatcher(event.target).removeEventListener(event.type, onDeferTimerComplete);
			const resultEvent:Event = ResultEvent.createEvent(result); 
			result = null;
			dispatchEvent(resultEvent);
		}
		protected function parseBytes(bytes:ByteArray):void
		{
			throw new AbstractMethodError();
		}
		protected static function skipWhitespace(bytes:ByteArray):void
		{
			var c:String;
			do
			{
				if (bytes.bytesAvailable == 0)
					return;
				c = getChar(bytes);
			} while (/\s/.test(c));
			bytes.position--;
		}
	}
}