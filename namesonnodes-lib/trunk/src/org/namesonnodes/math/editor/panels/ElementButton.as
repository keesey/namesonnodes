package org.namesonnodes.math.editor.panels
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	
	import org.namesonnodes.math.editor.drag.ElementDragger;
	import org.namesonnodes.math.editor.elements.MathMLElement;
	
	import spark.components.Button;
	
	[Event(name = "dataChange", type = "mx.events.FlexEvent")]
	public final class ElementButton extends Button
	{
		private var _data:MathMLElement;
		private var _elementFactory:IFactory;
		public function ElementButton()
		{
			super();
			buttonMode = true;
			useHandCursor = true;
			setStyle("skinFactory", new ClassFactory(ElementButtonSkin));
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		[Bindable(event = "dataChange")]
		public function get data():MathMLElement
		{
			return _data;
		}
		public function get elementFactory():IFactory
		{
			return _elementFactory;
		}
		public function set elementFactory(v:IFactory):void
		{
			if (_elementFactory != v)
			{
				_elementFactory = v;
				if (_elementFactory)
				{
					_data = _elementFactory.newInstance() as MathMLElement;
					if (_data)
						toolTip = _data.toolTipText;
					else
						toolTip = null;
				}
				else
					_data = null;
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
			}
		}
		private function onMouseDown(event:MouseEvent):void
		{
			if (_elementFactory)
			{
				const t:Timer = new Timer(1, 1);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, spawn);
				t.start();
			}
		}
		private function spawn(event:TimerEvent):void
		{
			Timer(event.target).removeEventListener(event.type, spawn);
			ElementDragger.INSTANCE.currentElement = _elementFactory.newInstance() as MathMLElement;
		}
	}
}