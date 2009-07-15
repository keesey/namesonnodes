package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	public interface Labelled extends Persistent
	{
		function get label():Label;
		function set label(value:Label):void;
	}
}