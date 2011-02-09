package garbuz.common.processing 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	import garbuz.common.commands.ICancelableCommand;
	import garbuz.common.events.EventSender;
	/**
	 * ...
	 * @author canab
	 */
	public class EnterFrameProcessor implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		private var _frameDispatcher:DisplayObject;
		private var _target:IProcessable;
		private var _timeLimit:int;
		
		public function EnterFrameProcessor(target:IProcessable, frameDispatcher:DisplayObject, timeLimit:int = 50) 
		{
			_target = target;
			_frameDispatcher = frameDispatcher;
			_timeLimit = timeLimit;
		}
		
		public function execute():void 
		{
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var startTime:int = getTimer();
			var currentTime:int = 0;
			var completed:Boolean = false;
			
			while (!completed && currentTime < _timeLimit)
			{
				completed = _target.process();
				currentTime = getTimer() - startTime;
			}
			
			if (completed)
			{
				stopProcessing();
				_completeEvent.dispatch();
			}
		}
		
		public function cancel():void 
		{
			stopProcessing();
		}
		
		private function stopProcessing():void 
		{
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_frameDispatcher = null;
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}

}