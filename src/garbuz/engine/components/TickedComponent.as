package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class TickedComponent extends Component
	{
		
		public function TickedComponent()
		{
			super();
		}
		
		override protected function onInitialize():void 
		{
			engine.addFrameListener(this);
		}
		
		override protected function onDispose():void 
		{
			engine.removeFrameListener(this);
		}
	}

}