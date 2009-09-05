package org.namesonnodes.flare
{
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.IRenderer;
	
	public final class NullRenderer implements IRenderer
	{
		public static const INSTANCE:IRenderer = new NullRenderer();
		public function NullRenderer()
		{
		}
		
		public function render(d:DataSprite):void
		{
			d.visible = false;
		}
	}
}