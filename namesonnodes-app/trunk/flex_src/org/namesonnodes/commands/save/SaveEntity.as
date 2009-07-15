package org.namesonnodes.commands.save
{
	import a3lbmonkeybrain.hippocampus.domain.Persistent;
	
	import org.namesonnodes.commands.Command;

	[RemoteClass(alias = "org.namesonnodes.commands.save.SaveEntity")]
	public final class SaveEntity implements Command
	{
		public var entity:Persistent;
		public function SaveEntity(entity:Persistent = null)
		{
			super();
			this.entity = entity;
		}
	}
}