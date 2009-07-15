package org.namesonnodes.domain.summaries
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	public interface Summarizeable extends Persistent
	{
		function toSummaryHTML():XML;
	}
}