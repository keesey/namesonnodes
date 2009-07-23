package org.namesonnodes.commands
{
	import flash.events.IEventDispatcher;

	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	public interface CommandFlow extends IEventDispatcher
	{
		function get flowName():String;
		function invoke(input:Object):void;
		function matches(input:Object):Boolean;
	}
}