package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;

	[RemoteClass(alias = "org.namesonnodes.domain.entities.SpecimenDefinition")]
	public final class SpecimenDefinition extends AbstractPersistent implements Definition
	{
		public function SpecimenDefinition()
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
			xml.appendChild(" is represented by catalogued specimen #" + id + "}");
			return xml.n
		}
	}
}