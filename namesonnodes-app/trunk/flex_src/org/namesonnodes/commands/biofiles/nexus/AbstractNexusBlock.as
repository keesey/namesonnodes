package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;
	
	import flash.utils.ByteArray;
	
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.Dataset;

	internal class AbstractNexusBlock extends AbstractLineReader implements NexusBlock
	{
		protected const _datasets:Vector.<Dataset> = new Vector.<Dataset>();
		protected const _taxa:TaxonIdentifierLibrary = new TaxonIdentifierLibrary();
		private var _localName:String;
		protected var _title:String;
		public function AbstractNexusBlock(localName:String)
		{
			super();
			if (!isNonEmptyString(localName))
				throw new BioFileError("No local name provided for NEXUS block.");
			_localName = localName;
		}
		public final function get datasets():Vector.<Dataset>
		{
			return _datasets;
		}
		public function get localName():String
		{
			return _localName;
		}
		public final function get taxa():TaxonIdentifierLibrary
		{
			return _taxa;
		}
		public final function get title():String
		{
			return _title;
		}
		public function parse(bytes:ByteArray):void
		{
			throw new AbstractMethodError();
		}
	}
}