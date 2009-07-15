package org.namesonnodes.flare.events
{
	import a3lbmonkeybrain.brainstem.collections.FiniteCollection;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public final class EntityClickEvent extends Event
	{
		public static const VERTEX_CLICK:String = "vertexClick";
		public static const ARC_CLICK:String = "arcClick";
		private var _entity:FiniteCollection;
		private var _triggerEvent:MouseEvent;
		public function EntityClickEvent(type:String, bubbles:Boolean, cancelable:Boolean, entity:FiniteCollection, triggerEvent:MouseEvent)
		{
			super(type, bubbles, cancelable);
			_entity = entity;
			_triggerEvent = triggerEvent;
		} 
		public function get entity():FiniteCollection
		{
			return _entity;
		}
		public function get triggerEvent():MouseEvent
		{
			return _triggerEvent;
		}
		override public function clone() : Event
		{
			return new EntityClickEvent(type, bubbles, cancelable, _entity, _triggerEvent);
		}
		override public function toString() : String
		{
			return formatToString("EntityClickEvent", "type", "bubbles", "cancelable", "eventPhase", "entity", "triggerEvent");
		}
	}
}