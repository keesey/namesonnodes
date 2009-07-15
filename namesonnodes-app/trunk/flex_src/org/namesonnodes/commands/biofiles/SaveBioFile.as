package org.namesonnodes.commands.biofiles
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.namesonnodes.commands.Command;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;

	[RemoteClass(alias = "org.namesonnodes.commands.biofiles.SaveBioFile")]
	public final class SaveBioFile implements Command
	{
		private const _datasets:ArrayCollection = new ArrayCollection();
		public var authority:AuthorityIdentifier;
		public var comments:String;
		public var mimeType:String;
		public var source:ByteArray;
		public function SaveBioFile()
		{
			super();
		}
		public function get datasets():ArrayCollection
		{
			return _datasets;
		}
		public function set datasets(value:ArrayCollection):void
		{
			_datasets.source = value ? value.source : [];
			_datasets.refresh();
		}
	}
}