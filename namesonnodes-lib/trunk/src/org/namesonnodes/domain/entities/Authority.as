package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.events.PropertyChangeEvent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Authority")]
	public final class Authority extends AbstractPersistent implements Identified, Labelled, Summarizeable
	{
		private var _label:Label;
		public function Authority()
		{
			super();
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public final function get label():Label
		{
			if (_label == null)
			{
				_label = new Label();
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", null, _label));
			}
			return _label;
		}
		public function set label(value:Label):void
		{
			value = value == null ? new Label() : value;
			_label = assessPropertyValue("label", value) as Label;
			flushPendingPropertyEvents();
		}
		public function toSummaryHTML():XML
		{
			return _label ? _label.toHTML() : <span>[Unlabelled]</span>;
		}
	}
}