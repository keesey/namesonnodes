package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	import a3lbmonkeybrain.hippocampus.domain.AbstractPersistent;
	
	import mx.events.PropertyChangeEvent;
	
	import org.namesonnodes.domain.summaries.Summarizeable;

	[Bindable]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.AuthorityIdentifier")]
	public final class AuthorityIdentifier extends AbstractPersistent implements Summarizeable
	{
		private var _entity:Authority;
		private var _nameSpace:Namespace;
		private var _uri:String;
		public function AuthorityIdentifier()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onURIChange, false, int.MAX_VALUE);
		}
		[Validator(type = "a3lbmonkeybrain.hippocampus.validate.MetadataValidator", required = true)]
		public function get entity():Authority
		{
			return _entity;
		}
		public function set entity(value:Authority):void
		{
			_entity = assessPropertyValue("entity", value) as Authority;
			flushPendingPropertyEvents();
		}
		[Transient]
		public function get nameSpace():Namespace
		{
			return _nameSpace;
		}
		[Validator(type = "mx.validators.RegExpValidator",
			expression = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$",
			required = true)]
		public function get uri():String
		{
			return _uri;
		}
		public function set uri(value:String):void
		{
			if (value != null && value.charAt(value.length - 1) == "/")
				value = value.substr(0, value.length - 1);
			_uri = assessPropertyValue("uri", value == null ? null : clean(value)) as String;
			flushPendingPropertyEvents();
		}
		public static function create(entity:Authority, uri:String):AuthorityIdentifier
		{
			const v:AuthorityIdentifier = new AuthorityIdentifier();
			v.entity = entity;
			v.uri = uri;
			return v;
		}
		private function onURIChange(event:PropertyChangeEvent):void
		{
			if (event.property == "uri")
				updateNameSpace();
		}
		public function toSummaryHTML():XML
		{
			const xml:XML = _entity ? _entity.toSummaryHTML() : <span>[No Authority]</span>;
			xml.appendChild(" <" + (_uri ? _uri : "No URI") + ">");
			return xml.normalize();
		}
		private function updateNameSpace():void
		{
			_nameSpace = assessPropertyValue("nameSpace", new Namespace(_uri)) as Namespace;
			flushPendingPropertyEvents();
		}
	}
}