package org.namesonnodes.commands.biofiles
{
	import com.adobe.crypto.SHA1;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.IList;
	import mx.rpc.Fault;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.AbstractCommandFlow;
	import org.namesonnodes.commands.collections.CommandList;
	import org.namesonnodes.commands.entities.NullCommand;
	import org.namesonnodes.commands.resolve.ResolveURI;
	import org.namesonnodes.commands.save.SaveEntity;
	import org.namesonnodes.data.services.CommandService;
	import org.namesonnodes.domain.entities.Authority;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Dataset;

	public final class UploadBioFileFlow extends AbstractCommandFlow
	{
		private static const FORMATS:Vector.<BioFileFormat> = new Vector.<BioFileFormat>(); 
		private const fileRef:FileReference = new FileReference();
		private const progressPanel:ProgressPanel = new ProgressPanel();
		private const resolveURI:ResolveURI = new ResolveURI();
		private const service:CommandService = new CommandService();
		private var data:ByteArray;
		private var format:BioFileFormat;
		public function UploadBioFileFlow()
		{
			super();
			addEventListener(FaultEvent.FAULT, closeProgressPanel, false, int.MAX_VALUE);
			addEventListener(ResultEvent.RESULT, closeProgressPanel, false, int.MAX_VALUE);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
		}
		private static function get filters():Array
		{
			const filters:Array = [];
			for each (var format:BioFileFormat in FORMATS)
				filters.push(format.filter);
			filters.push(new FileFilter("All Files", "*.*"));
			return filters;
		}
		override public function get flowName() : String
		{
			return "Upload a bioinformatics file.";
		}
		private function clearFormat():void
		{
			if (format)
			{
				format.removeEventListener(FaultEvent.FAULT, onFormatFault);
				format.removeEventListener(ResultEvent.RESULT, onFormatResult);
				format = null;
			}
		}
		private function closeProgressPanel(event:Event):void
		{
			progressPanel.close();
		}
		override public function invoke(input:Object) : void
		{
			if (input == null)
			{
				if (!fileRef.browse(filters))
				{
					dispatchEvent(InvokeEvent.createEvent());
					dispatchEvent(FaultEvent.createEvent(new Fault("File Browse Error",
						"Cannot browse for files.")));
					return;
				}
			}
			else
			{
				if (input is String)
				{
					data = new ByteArray();
					data.writeMultiByte(input as String, "us-ascii");
				}
				else if (input is ByteArray)
					data = input as ByteArray;
				else
				{
					data = new ByteArray();
					data.writeObject(input);
				}
				dispatchEvent(InvokeEvent.createEvent());
				lookUpData();
			}
		}
		private function lookUpData():void
		{
			data.position = 0;
			const sourceHash:String = SHA1.hash(data.readMultiByte(data.length, "us-ascii"));
			resolveURI.uri = "urn:sha1:" + sourceHash;
			service.executeCommand(resolveURI)
				.addResponder(new Responder(onResolveResult, dispatchEvent));
		}
		override public function matches(input:Object) : Boolean
		{
			return true; 
		}
		private function onErrorEvent(event:ErrorEvent):void
		{
			dispatchEvent(FaultEvent.createEvent(new Fault(event.type, event.text)));
		}
		private function onFormatFault(event:FaultEvent):void
		{
			clearFormat();
			dispatchEvent(event);
		}
		private function onFormatResult(event:ResultEvent):void
		{
			clearFormat();
			try
			{
				if (event.result is ParseResult)
				{
					const command:SaveBioFile = new SaveBioFile();
					const result:ParseResult = event.result as ParseResult;
					progressPanel.title = "Uploading " + fileRef.name + "...";
					const identifier:AuthorityIdentifier = new AuthorityIdentifier();
					identifier.uri = resolveURI.uri;
					identifier.entity = new Authority();
					identifier.entity.label.name = fileRef.name;
					identifier.entity.label.italics = true;
					result.authorize(identifier);
					command.authority = identifier;
					command.comments = result.comments;
					for each (var dataset:Dataset in result.datasets)
						command.datasets.addItem(dataset);
					command.mimeType = result.mimeType;
					command.source = fileRef.data;
					service.executeCommand(command)
						.addResponder(new Responder(dispatchEvent, dispatchEvent));
				}
				else
					dispatchEvent(FaultEvent.createEvent(new Fault("Parse Error",
						"Invalid parse result.")));
			}
			catch(e:Error)
			{
				handleError(e);
			}
		}
		private function onResolveResult(event:ResultEvent):void
		{
			if (event.result is AuthorityIdentifier)
				dispatchEvent(event);
			else
				parseData();
		}
		private function parseData():void
		{
			try
			{
				for each (var format:BioFileFormat in FORMATS)
				{
					if (format.matches(data))
					{
						this.format = format;
						format.addEventListener(FaultEvent.FAULT, onFormatFault);
						format.addEventListener(ResultEvent.RESULT, onFormatResult);
						progressPanel.title = "Parsing data...";
						progressPanel.open(null);
						format.invoke(data);
						return;
					}
				}
			}
			catch (e:Error)
			{
				handleError(e);
				return;
			}
			dispatchEvent(FaultEvent.createEvent(new Fault("Unrecognized Format",
				"Unrecognized bioinformatics file format.")));
		}
	}
}