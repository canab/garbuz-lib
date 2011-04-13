package garbuz.engine.components 
{
	import flash.events.Event;

	import garbuz.engine.core.Component;

	public class PauseOnDeactivate extends Component
	{
		public function PauseOnDeactivate()
		{
			super();
		}
		
		override protected function onInitialize():void 
		{
			engine.root.addEventListener(Event.ACTIVATE, onActivate);
			engine.root.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		override protected function onDispose():void 
		{
			engine.root.removeEventListener(Event.ACTIVATE, onActivate);
			engine.root.removeEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		private function onDeactivate(e:Event):void 
		{
			engine.stop();
		}
		
		private function onActivate(e:Event):void 
		{
			engine.start();
		}
		
	}

}