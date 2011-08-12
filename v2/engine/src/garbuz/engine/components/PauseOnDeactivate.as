package garbuz.engine.components 
{
	import flash.display.Shape;
	import flash.events.Event;

	import garbuz.engine.core.Component;

	public class PauseOnDeactivate extends Component
	{
		private var _eventDispatcher:Shape = new Shape();

		public function PauseOnDeactivate()
		{
			super();
		}
		
		override protected function onInitialize():void 
		{
			_eventDispatcher.addEventListener(Event.ACTIVATE, onActivate);
			_eventDispatcher.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		override protected function onDispose():void 
		{
			_eventDispatcher.removeEventListener(Event.ACTIVATE, onActivate);
			_eventDispatcher.removeEventListener(Event.DEACTIVATE, onDeactivate);
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