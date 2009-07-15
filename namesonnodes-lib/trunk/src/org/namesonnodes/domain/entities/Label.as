package org.namesonnodes.domain.entities
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.IPropertyChangeNotifier;
	import mx.events.PropertyChangeEvent;
	import mx.utils.UIDUtil;
	
	[Bindable]
	[Event(name = "propertyChange", type = "mx.events.PropertyChangeEvent")]
	[RemoteClass(alias = "org.namesonnodes.domain.entities.Label")]
	public final class Label extends EventDispatcher implements IPropertyChangeNotifier
	{
		private var _abbr:String;
		private var _abbrOrName:String;
		private var _italics:Boolean;
		private var _name:String;
		private var _uid:String;
		public function Label()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onAbbrChange, false, int.MAX_VALUE);
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onNameChange, false, int.MAX_VALUE);
		}
		[Validator(type = "mx.validators.StringValidator", maxLength = 64, required = false)]
		public function get abbr():String
		{
			return _abbr;
		}
		public function set abbr(value:String):void
		{
			value = clean(value);
			if (value == "") value = null;
			if (_abbr != value)
			{
				const event:Event = PropertyChangeEvent.createUpdateEvent(this, "abbr", _abbr, value);
				_abbr = value;
				dispatchEvent(event);
			}
		}
		[Transient]
		public function get abbrOrName():String
		{
			return _abbrOrName;
		}
		public function get italics():Boolean
		{
			return _italics;
		}
		public function set italics(value:Boolean):void
		{
			if (_italics != value)
			{
				const event:Event = PropertyChangeEvent.createUpdateEvent(this, "italics", _italics, value);
				_italics = value;
				dispatchEvent(event);
			}
		}
		[Validator(type = "mx.validators.StringValidator", minLength = 1, maxLength = 256, required = true)]
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			value = clean(value);
			if (value == "") value = null;
			if (_name != value)
			{
				const event:Event = PropertyChangeEvent.createUpdateEvent(this, "name", _name, value);
				_name = value;
				dispatchEvent(event);
			}
		}
		[Transient]
		/**
		 * @inheritDoc
		 */
		public final function get uid():String
		{
			if (_uid == null)
				_uid = UIDUtil.createUID();
			return _uid;
		}
		/**
		 * @private
		 */
		public final function set uid(value:String):void
		{
			// Do nothing.
		}
		private function onAbbrChange(event:PropertyChangeEvent):void
		{
			if (event.property == "abbr")
				updateAbbrOrName();
		}
		private function onNameChange(event:PropertyChangeEvent):void
		{
			if (event.property == "name" && _abbr == null)
				updateAbbrOrName();
		}
		private function updateAbbrOrName():void
		{
			var value:String = _abbr == null ? _name : _abbr;
			if (_abbrOrName != value)
			{
				const event:Event = PropertyChangeEvent.createUpdateEvent(this, "abbrOrName", _abbrOrName, value);
				_abbrOrName = value;
				dispatchEvent(event);
			}
		}
		public function toAbbrHTML():XML
		{
			if (abbrOrName == null)
				return <span>[Unnamed]</span>;
			if (_italics)
				return <span><i>{abbrOrName}</i></span>;
			return <span>{abbrOrName}</span>;
		}
		public function toHTML():XML
		{
			if (_name == null)
				return <span>[Unnamed]</span>;
			if (_italics)
				return <span><i>{_name}</i></span>;
			return <span>{_name}</span>;
		}
	}
}