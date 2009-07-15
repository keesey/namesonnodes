package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.events.PropertyChangeEvent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Qualified")]
	public class AbstractQualified extends AbstractPersistent implements Authorized, Labelled, Summarizeable
	{
		private var _authority:AuthorityIdentifier;
		private var _label:Label;
		private var _localName:String;
		private var _qName:QName;
		public function AbstractQualified()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onAuthorityChange, false, int.MAX_VALUE);
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onLocalNameChange, false, int.MAX_VALUE);
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public final function get authority():AuthorityIdentifier
		{
			return _authority;
		}
		public final function set authority(value:AuthorityIdentifier):void
		{
			_authority = assessPropertyValue("authority", value) as AuthorityIdentifier;
			flushPendingPropertyEvents();
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
		public final function set label(value:Label):void
		{
			value = value == null ? new Label() : value;
			_label = assessPropertyValue("label", value) as Label;
			flushPendingPropertyEvents();
		}
		[Validator(type = "mx.validators.RegExpValidator", expression = "^[A-Za-z0-9_+%:/-]+$", required = true)]
		public final function get localName():String
		{
			return _localName;
		}
		public final function set localName(value:String):void
		{
			_localName = assessPropertyValue("localName", value) as String;
			flushPendingPropertyEvents();
		}
		[Transient]
		public final function get qName():QName
		{
			return _qName;
		}
		public final function set qName(value:QName):void
		{
		}
		private function onAuthorityChange(event:PropertyChangeEvent):void
		{
			if (event.property == "authority")
			{
				if (event.oldValue is AuthorityIdentifier)
					AuthorityIdentifier(event.oldValue).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onAuthorityURIChange);
				if (event.newValue is AuthorityIdentifier)
					AuthorityIdentifier(event.newValue).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onAuthorityURIChange);
				updateQName();
			}
		}
		private function onAuthorityURIChange(event:PropertyChangeEvent):void
		{
			if (event.property == "uri")
				updateQName();
		}
		private function onLocalNameChange(event:PropertyChangeEvent):void
		{
			if (event.property == "localName")
				updateQName();
		}
		public function toSummaryHTML():XML
		{
			return _label ? _label.toHTML() : <span>[Unlabelled]</span>;
		}
		private function updateQName():void
		{
			_qName = assessPropertyValue("qName", new QName(_authority ? _authority.uri : null, _localName)) as QName;
			flushPendingPropertyEvents(); 
		}
	}
}