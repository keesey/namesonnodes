package org.namesonnodes.components.commands
{
	import mx.core.IVisualElement;
	
	import org.namesonnodes.commands.Command;

	public interface CommandForm extends IVisualElement
	{
		function createCommand():Command;
	}
}