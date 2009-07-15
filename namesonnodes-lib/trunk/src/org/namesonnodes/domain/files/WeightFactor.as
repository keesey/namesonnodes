package org.namesonnodes.domain.files
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public final class WeightFactor extends EventDispatcher
	{
		private var _type:WeightType = null;
		private var _value:Number = 0.0;
		public function WeightFactor()
		{
			super();
		}
		[Bindable(event = "typeChanged")]
		public function get type():WeightType
		{
			return _type;
		}
		public function set type(v:WeightType):void
		{
			if (_type != v)
			{
				_type = v;
				dispatchEvent(new Event("typeChanged"));
			}
		}
		[Bindable(event = "valueChanged")]
		public function get value():Number
		{
			return _value;
		}
		public function set value(v:Number):void
		{
			if (_value != v)
			{
				_value = v;
				dispatchEvent(new Event("valueChanged"));
			}
		}
	}
}