package org.namesonnodes.commands.biofiles.nexus
{
	import flash.utils.ByteArray;
	
	import org.namesonnodes.domain.entities.Dataset;

	public interface NexusBlock
	{
		function get datasets():Vector.<Dataset>;
		function get taxa():TaxonIdentifierLibrary;
		function get title():String;
		function parse(bytes:ByteArray):void;
	}
}