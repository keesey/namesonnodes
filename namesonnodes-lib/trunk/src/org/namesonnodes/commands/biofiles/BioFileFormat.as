package org.namesonnodes.commands.biofiles
{
	import flash.net.FileFilter;
	
	import org.namesonnodes.commands.CommandFlow;

	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	public interface BioFileFormat extends CommandFlow
	{
		function get filter():FileFilter;
	}
}