package org.namesonnodes.domain.summaries
{
	import a3lbmonkeybrain.brainstem.w3c.xml.extractText;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Bindable]
	[RemoteClass(alias="org.namesonnodes.domain.summaries.SummaryItem")]
	public final class SummaryItem extends EventDispatcher
	{
		private var _className:String;
		private var _id:uint;
		private var _textHTML:XML;
		public function SummaryItem(id:uint=0, textHTML:XML=null, className:String = null)
		{
			super();
			_id = id;
			_textHTML = (textHTML == null) ? new XML() : textHTML;
			_className = className;
		}
		[Bindable(event="classNameChanged")]
		public function get className():String
		{
			return _className;
		}
		public function set className(value:String):void
		{
			if (_className != value)
			{
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}
		[Bindable(event="idChanged")]
		public function get id():uint
		{
			return _id;
		}
		public function set id(value:uint):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}
		[Bindable(event="textHTMLChanged")]
		[Transient]
		public function get text():String
		{
			return extractText(_textHTML);
		}
		[Bindable(event="textHTMLChanged")]
		public function get textHTML():XML
		{
			return _textHTML;
		}
		public function set textHTML(value:XML):void
		{
			value = (value == null) ? new XML() : value;
			if (_textHTML != value)
			{
				_textHTML = value;
				dispatchEvent(new Event("textHTMLChanged"));
			}
		}
	}
}