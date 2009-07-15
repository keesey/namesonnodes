package org.namesonnodes.commands.resolve
{
	import mx.utils.OnDemandEventDispatcher;
	
	import org.namesonnodes.commands.Command;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.commands.resolve.ResolveTaxonIdentifier")]
	public final class ResolveTaxonIdentifier extends OnDemandEventDispatcher implements Command
	{
		public var qname:String;
		public function ResolveTaxonIdentifier(qname:Object = null)
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