package org.namesonnodes.commands.resolve
{
	import org.namesonnodes.commands.core.Command;
	
	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.resolve.ResolveDataset")]
	public final class ResolveDataset implements Command
	{
		public var qname:String;
		public function ResolveDataset(qname:Object = null)
		{
			super();
			if (qname == null)
				this.qname = null;
			else if (qname is QName)
				this.qualifiedName = qname as QName;
			else
				this.qname = String(qname);
		}
		[Transient]
		public function set qualifiedName(value:QName):void
		{
			qname = value.uri + "::" + value.localName;
		}
	}
}