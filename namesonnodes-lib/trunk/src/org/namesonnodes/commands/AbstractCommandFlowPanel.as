package org.namesonnodes.commands
{
	import a3lbmonkeybrain.brainstem.errors.AbstractMethodError;
	import a3lbmonkeybrain.visualcortex.alerts.alertError;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import spark.components.Panel;

	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	public class AbstractCommandFlowPanel extends Panel implements CommandFlow
	{
		public function AbstractCommandFlowPanel()
		{
			super();
			title = flowName;
		}
		public function get flowName():String
		{
			throw new AbstractMethodError();
		}
		private function close():void
		{
			try
			{
				PopUpManager.removePopUp(this);
			}
			catch (e:Error)
			{
				alertError(e);
			}
		}
		protected final function commitResult(result:Object):void
		{
			close();
			dispatchEvent(ResultEvent.createEvent(result));
		}
		protected final function onFault(event:FaultEvent):void
		{
			close();
			dispatchEvent(event);
		}
		public final function invoke(input:Object):void
		{
			readInput(input);
			PopUpManager.addPopUp(this, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(this);
			dispatchEvent(new InvokeEvent(InvokeEvent.INVOKE));
		}
		public function matches(input:Object):Boolean
		{
			return false;
		}
		protected function readInput(input:Object):void
		{
			throw new AbstractMethodError();
		}
	}
}