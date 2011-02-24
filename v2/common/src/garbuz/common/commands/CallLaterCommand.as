package garbuz.common.commands 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import garbuz.common.events.EventSender;

	public class CallLaterCommand implements ICancelableCommand
	{
		private var _func:Function;
		private var _args:Array;
		private var _thisObject:Object;
		private var _interval:int;
		private var _timer:Timer;
		private var _completeEvent:EventSender = new EventSender(this);
		
		public function CallLaterCommand(func:Function = null, interval:int = 10,
			args:Array = null, thisObject:Object = null) 
		{
			_interval = interval;
			_func = func;
			_args = args;
			_thisObject = thisObject;
		}
		
		public function execute():void
		{
			_timer = new Timer(_interval, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			disposeTimer();
			if (_func != null)
				_func.apply(_thisObject, _args);
			_completeEvent.dispatch();
		}
		
		private function disposeTimer():void 
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
		}
		
		public function cancel():void
		{
			if (_timer)
				disposeTimer();
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}

}