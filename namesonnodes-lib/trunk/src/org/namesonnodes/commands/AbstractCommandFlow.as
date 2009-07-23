package org.namesonnodes.commands
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	
	import flash.events.EventDispatcher;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	public class AbstractCommandFlow extends EventDispatcher implements CommandFlow
	{
		public function AbstractCommandFlow()
		{
			super();
		}
		public function get flowName():String
		{
			throw new AbstractMethodError();
		}
		protected function handleError(e:Error):void
		{
			const fault:Fault = new Fault(e.name, e.message);
			dispatchEvent(FaultEvent.createEvent(fault));
		}
		public function invoke(input:Object):void
		{
			throw new AbstractMethodError();
		}
		public function matches(input:Object):Boolean
		{
			return false;
		}
	}
}