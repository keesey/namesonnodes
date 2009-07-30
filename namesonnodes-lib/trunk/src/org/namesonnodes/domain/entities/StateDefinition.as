package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;

	[RemoteClass(alias = "org.namesonnodes.domain.entities.StateDefinition")]
	public final class StateDefinition extends AbstractPersistent implements Definition
	{
		public function StateDefinition()
		{
			super();
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = <span/>;
			xml.appendChild(":= {");
			xml.appendChild(<i>x</i>);
			xml.appendChild("| ");
			xml.appendChild(<i>x</i>);
			xml.appendChild(" exhibits character state #" + id + "}");
			return xml.n
		}
	}
}