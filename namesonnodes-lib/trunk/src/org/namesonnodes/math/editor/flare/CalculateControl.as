package org.namesonnodes.math.editor.flare
{
	import a3lbmonkeybrain.brainstem.assert.assertNotNull;
	import a3lbmonkeybrain.brainstem.filter.filterType;
	import a3lbmonkeybrain.brainstem.resolve.XMLResolver;
	
	import flare.vis.controls.ClickControl;
	import flare.vis.data.NodeSprite;
	
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.math.editor.elements.MathMLElement;

	[Event(name = "error", type = "flash.events.ErrorEvent")]
	[Event(name = "result", type = "mx.rpc.events.ResultEvent")]
	public final class CalculateControl extends ClickControl
	{
		private var resolver:XMLResolver;
		public function CalculateControl(resolver:XMLResolver)
		{
			super(filterType(NodeSprite), 1, onClick);
			assertNotNull(resolver);
			this.resolver = resolver;
		}
		private function onClick(nodeSprite:NodeSprite):void
		{
			if (nodeSprite.data is MathMLElement)
			{
				try
				{
					const result:Object = resolver.resolveXML(MathMLElement(nodeSprite.data).mathML);
					dispatchEvent(ResultEvent.createEvent(result));
				}
				catch (e:Error)
				{
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));
				}
			}
		}
	}
}