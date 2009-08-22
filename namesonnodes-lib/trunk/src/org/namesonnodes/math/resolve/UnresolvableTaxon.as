package org.namesonnodes.math.resolve
{
	import a3lbmonkeybrain.brainstem.resolve.Unresolvable;
	
	public final class UnresolvableTaxon implements Unresolvable
	{
		public static const INSTANCE:UnresolvableTaxon = new UnresolvableTaxon();
		public function UnresolvableTaxon()
		{
			super();
		}
		public function toString():String
		{
			return "[UnresolvableTaxon]";
		}
	}
}