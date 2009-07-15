package org.namesonnodes.data.services
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.mx_internal;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import org.namesonnodes.commands.Command;

	use namespace mx_internal;

	public final class CommandService extends RemoteObject
	{
		public function CommandService()
		{
			super("command");
		}
		public function get execute():AbstractOperation
		{
			return getOperation("executeFlex");
		}
		public function executeCommand(command:Command):AsyncToken
		{
			return getOperation("executeFlex").send(command);
		}
		public function executeFaultTest(code:String, string:String, detail:String = null):AsyncToken
		{
			const fault:Fault = new Fault(code, string, detail);
			const token:AsyncToken = new AsyncToken();
			const timer:Timer = new Timer(500, 1);
			const onTimerComplete:Function = function(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				const faultEvent:FaultEvent = FaultEvent.createEvent(fault, token);
				token.mx_internal::applyFault(faultEvent);
				dispatchEvent(faultEvent);
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
			return token;
		}
		public function executeResultTest(result:Object):AsyncToken
		{
			const token:AsyncToken = new AsyncToken();
			const timer:Timer = new Timer(1000, 1);
			const onTimerComplete:Function = function(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				const resultEvent:ResultEvent = ResultEvent.createEvent(result, token);
				token.mx_internal::applyResult(resultEvent);
				dispatchEvent(resultEvent);
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
			return token;
		}
	}
}