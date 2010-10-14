package garbuz.common.commands 
{
	import garbuz.common.events.EventSender;
	/**
	 * ...
	 * @author canab
	 */
	public class WaitForEventCommand implements ICancelableCommand
	{
		private var _targetEvent:EventSender = new EventSender(this);
		private var _completeEvent:EventSender = new EventSender(this);
		
		public function WaitForEventCommand(event:EventSender) 
		{
			_targetEvent = event;
		}
		
		/* INTERFACE garbuz.common.commands.ICancelableCommand */
		
		public function cancel():void 
		{
			if (_targetEvent.hasListener(onTargetEvent))
				_targetEvent.removeListener(onTargetEvent);
		}
		
		public function execute():void 
		{
			_targetEvent.addListener(onTargetEvent);
		}
		
		private function onTargetEvent():void 
		{
			_targetEvent.removeListener(onTargetEvent);
			_completeEvent.dispatch();
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}

}